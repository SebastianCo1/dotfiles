import { randomUUID } from "node:crypto";
import { env } from "../config/env.js";
import { unauthorized } from "../errors/app-error.js";
import { prisma } from "../lib/prisma.js";
import { hashPassword, performDummyPasswordCheck, verifyPassword } from "./password.service.js";
import {
  hashRefreshToken,
  issueAccessToken,
  issueRefreshToken,
  type AuthRole,
  verifyRefreshToken,
} from "./token.service.js";

interface SessionMetadata {
  ipAddress?: string;
  userAgent?: string;
}

interface AuthUser {
  id: string;
  email: string;
  name: string;
  role: AuthRole;
}

export interface AuthResult {
  accessToken: string;
  refreshToken: string;
  accessTokenExpiresIn: number;
  sessionExpiresAt: string;
  user: AuthUser;
}

function sessionData(user: AuthUser, metadata: SessionMetadata) {
  const sessionId = randomUUID();
  const refreshTokenId = randomUUID();
  const expiresAt = new Date(Date.now() + env.refreshTokenTtlSeconds * 1000);
  const refreshToken = issueRefreshToken(user.id, sessionId, refreshTokenId);

  return {
    sessionId,
    refreshToken,
    expiresAt,
    record: {
      id: sessionId,
      userId: user.id,
      refreshTokenHash: hashRefreshToken(refreshToken),
      refreshTokenJti: refreshTokenId,
      expiresAt,
      ipAddress: metadata.ipAddress,
      userAgent: metadata.userAgent,
    },
  };
}
// xxxxxxxx
function authResult(user: AuthUser, sessionId: string, refreshToken: string, expiresAt: Date): AuthResult {
  return {
    accessToken: issueAccessToken(user.id, sessionId, user.role),
    refreshToken,
    accessTokenExpiresIn: env.accessTokenTtlSeconds,
    sessionExpiresAt: expiresAt.toISOString(),
    user,
  };
}
// aaaaaaaaaaaa
export async function register(
  input: { email: string; password: string; name: string },
  metadata: SessionMetadata,
): Promise<AuthResult> {
  const passwordHash = await hashPassword(input.password);
  // wwwwwwwwwwwwww
  return prisma.$transaction(async (tx) => {
    const user = await tx.user.create({
      data: { email: input.email, passwordHash, name: input.name },
      select: { id: true, email: true, name: true, role: true },
    });
    const session = sessionData(user, metadata);
    await tx.authSession.create({ data: session.record });
    return authResult(user, session.sessionId, session.refreshToken, session.expiresAt);
  });
}

export async function login(
  input: { email: string; password: string },
  metadata: SessionMetadata,
): Promise<AuthResult> {
  const user = await prisma.user.findUnique({
    where: { email: input.email },
    select: { id: true, email: true, passwordHash: true, name: true, role: true, status: true },
  });

  const passwordIsValid = user
    ? await verifyPassword(input.password, user.passwordHash)
    : (await performDummyPasswordCheck(input.password), false);

  if (!user || !passwordIsValid || user.status !== "ACTIVE") {
    throw unauthorized("Email or password is incorrect");
  }

  const publicUser: AuthUser = { id: user.id, email: user.email, name: user.name, role: user.role };
  const session = sessionData(publicUser, metadata);
  await prisma.authSession.create({ data: session.record });
  return authResult(publicUser, session.sessionId, session.refreshToken, session.expiresAt;
}

type RefreshResult = { kind: "ok"; result: AuthResult } | { kind: "invalid" };

export async function rotateRefreshToken(oldRefreshToken: string): Promise<AuthResult> {
  let payload;
  try {
    payload = verifyRefreshToken(oldRefreshToken);
  } catch {
    throw unauthorized("Refresh token is invalid or expired");
  }

  const now = new Date();
  const oldHash = hashRefreshToken(oldRefreshToken);

  const rotation = await prisma.$transaction<RefreshResult>(async (tx) => {
    const session = await tx.authSession.findUnique({
      where: { id: payload.sid },
      include: {
        user: { select: { id: true, email: true, name: true, role: true, status: true } },
      },
    });

    if (!session || session.userId !== payload.sub) return { kind: "invalid" };

    const presentedTokenIsCurrent =
      session.refreshTokenHash === oldHash && session.refreshTokenJti === payload.jti;

    if (!presentedTokenIsCurrent) {
      await tx.authSession.updateMany({
        where: { id: session.id, revokedAt: null },
        data: { revokedAt: now, revocationReason: "REFRESH_TOKEN_REUSE" },
      });
      return { kind: "invalid" };
    }

    if (session.revokedAt || session.expiresAt <= now || session.user.status !== "ACTIVE") {
      const reason = session.user.status !== "ACTIVE" ? "USER_DISABLED" : "EXPIRED";
      await tx.authSession.updateMany({
        where: { id: session.id, revokedAt: null },
        data: { revokedAt: now, revocationReason: reason },
      });
      return { kind: "invalid" };
    }

    const remainingSeconds = Math.max(1, Math.floor((session.expiresAt.getTime() - now.getTime()) / 1000));
    const nextTokenId = randomUUID();
    const nextRefreshToken = issueRefreshToken(session.user.id, session.id, nextTokenId, remainingSeconds);
    const nextHash = hashRefreshToken(nextRefreshToken);

    const updated = await tx.authSession.updateMany({
      where: {
        id: session.id,
        refreshTokenHash: oldHash,
        refreshTokenJti: payload.jti,
        revokedAt: null,
        expiresAt: { gt: now },
      },
      data: {
        refreshTokenHash: nextHash,
        refreshTokenJti: nextTokenId,
        rotationCounter: { increment: 1 },
        lastUsedAt: now,
      },
    });

    if (updated.count !== 1) {
      await tx.authSession.updateMany({
        where: { id: session.id, revokedAt: null },
        data: { revokedAt: now, revocationReason: "REFRESH_TOKEN_REUSE" },
      });
      return { kind: "invalid" };
    }

    const user: AuthUser = {
      id: session.user.id,
      email: session.user.email,
      name: session.user.name,
      role: session.user.role,
    };
    return { kind: "ok", result: authResult(user, session.id, nextRefreshToken, session.expiresAt) };
  });

  if (rotation.kind === "invalid") throw unauthorized("Refresh token is invalid or has been reused");
  return rotation.result;
}

export async function revokeSession(refreshToken: string): Promise<void> {
  await prisma.authSession.updateMany({
    where: { refreshTokenHash: hashRefreshToken(refreshToken), revokedAt: null },
    data: { revokedAt: new Date(), revocationReason: "LOGOUT" },
  });
}

export async function revokeAllUserSessions(userId: string): Promise<void> {
  await prisma.authSession.updateMany({
    where: { userId, revokedAt: null },
    data: { revokedAt: new Date(), revocationReason: "LOGOUT_ALL" },
  });
}
