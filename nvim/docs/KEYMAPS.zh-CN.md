# 我的 Neovim / LazyVim 开发快捷键手册

适用：React、Next.js、TypeScript、Node.js 全栈开发。核对日期：2026-09-07。

这是一份按照你**当前实际配置、已安装插件源码和终端运行时映射**整理的工作手册，不是通用 LazyVim 快捷键表。覆盖打开项目、读代码、编辑、重构、运行、测试、排错、Git、提交 PR 和恢复工作现场。

## 1. 先理解按键与适用范围

| 记号 | 如何操作 |
|---|---|
| `Space f f` | 依次按空格、f、f；不是同时按 |
| `Ctrl-s` | 按住 Control 再按 s，不是 macOS Command |
| `Alt-j` | Option/Alt + j；终端须将 Option 配为 Alt/Meta |
| `Shift-Tab` | 按住 Shift 再按 Tab |
| `N` / `I` / `V` / `T` | Normal 普通 / Insert 插入 / Visual 选择 / Terminal 输入模式 |
| `:命令` | 按 Esc 回到普通模式，输入冒号命令，最后按 Enter |
| `<leader>` | 你的配置是空格：`Space` |
| `<localleader>` | 你的配置是反斜杠：`\`，不是空格 |
| `cwd` | 当前工作目录，可用 `:pwd` 查看 |
| Root Dir | LazyVim 识别的项目根目录；不一定等于当前文件所在文件夹 |

`Space` 开头的键可以稍作停顿查看 which-key 提示。你的 `timeoutlen` 为 300ms；`Space c`、`Space d`、`Space r` 本身也有动作，输入更长组合要连续完成。

**Zed 的 Vim 模式与这份 Neovim 配置是两套环境。** 通用 Vim 操作可以迁移理解；这里的 LazyVim、Lua 插件和 `Space` 映射不会因为 Zed 开启 Vim 模式就自动载入。下文“编辑器中的任务”用于对应你熟悉的工作方式，不代表 Zed 的实际快捷键。

当前配置入口：`/Users/lucas/.config/nvim` → `/Users/lucas/.config/dotfiles/nvim`。本轮只生成文档，没有修改快捷键、安装插件或执行 Git 提交。

## 2. 从编辑器功能快速找到对应操作

| 编辑器中的任务 | 当前 Neovim 操作 |
|---|---|
| 快速打开项目文件 | `Space Space` 或 `Space f f` |
| 项目全文搜索 | `Space /` |
| 查找当前文件中的符号 | `Space s s` |
| 打开文件树 | `Space e` |
| 切换已打开文件 | `Space ,` 或 `[b` / `]b` |
| 左右拆分编辑区 | `sv` |
| 跳转定义 / 查看引用 | `gd` / `gr` |
| 悬停文档 | `K` |
| 重命名变量、函数、组件 | `Space c r` |
| Quick Fix / Code Action | `Space c a` |
| 接受补全 | 插入模式 `Ctrl-y` |
| 格式化并保存 | `Space c f`，然后 `Ctrl-s`；默认启用自动格式化时保存也会触发 |
| 项目问题面板 | `Space x x` |
| 项目终端 | `Space f t` 或 `Ctrl-/` |
| 查看 Git 文件变化 | `Space g s` 或 `Space g e` |
| 查看当前改动块 | `Space g h p` |
| 暂存当前改动块 | `Space g h s` |
| 提交、推送 | Neo-tree Git 面板内 `gc`、`gp`，或终端 Git 命令 |
| 全局替换 | `Space s r` |
| 恢复项目会话 | `Space q s` |

## 3. 打开项目与管理文件

先在项目根目录启动，尤其是 Next.js monorepo；你的 vtsls 配置使用 `.git` 根标记并要求 workspace，散落在项目外的单文件不一定启动 TS LSP。

```sh
cd /path/to/project
nvim .
```

### 3.1 文件查找与已打开文件

| 模式 | 按键 / 命令 | 作用 |
|---|---|---|
| N | `Space Space` / `Space f f` | 项目根目录查找文件，使用 fzf-lua |
| N | `Space f F` | cwd 查找文件 |
| N | `;f` | 自定义 Telescope 查找；包含隐藏文件，尊重 ignore |
| N | `Space f g` | 查找 Git 跟踪文件 |
| N | `Space f r` / `Space f R` | 最近文件 / cwd 范围内最近文件 |
| N | `Space ,` / `Space f b` | 已打开 buffer 列表 |
| N | `\\` | 连按两次反斜杠，打开 Telescope buffers |
| N | `[b` / `]b` | 上一个 / 下一个 buffer |
| N | `Space b b` / `Space` 加反引号 | 当前与上一个 buffer 来回切换 |
| N | `Space b d` | 关闭当前 buffer，尽量保留窗口布局 |
| N | `Space b o` | 关闭其他 buffer |
| N | `Space b i` | 关闭不可见的 buffer |
| N | `Space b D` | 关闭当前 buffer 及其窗口 |
| N | `Space f n` | 新建未命名 buffer；保存时需要提供路径 |
| N | `:edit path/to/file.tsx` | 打开指定文件；不存在时创建编辑缓冲区 |
| N | `:write path/to/file.tsx` | 为新文件指定保存路径 |
| N | `Space f c` | 查找 Neovim 配置文件 |
| N | `Space f P` | 查找安装目录中的插件文件 |

**buffer 是文件内容，window 是显示区域，tab 是一组窗口布局。** 你的 bufferline 设置了 `mode = "tabs"`，顶部标签不能等同于“所有已打开文件”。切换文件优先用 `Space ,`。

### 3.2 Neo-tree 文件树：先按 `Space e`

以下按键只在文件树窗口里使用；此时 `s` 不再是 Flash，`r` 是文件重命名。

| 按键 | 作用 |
|---|---|
| `Space e` / `Space E` | 切换项目根目录 / cwd 文件树 |
| `Enter` / `l` | 打开文件或展开目录 |
| `h` | 折叠节点 |
| `Backspace` | 向上一级目录 |
| `.` | 将当前节点设为树根 |
| `a` / `A` | 新建文件 / 新建目录 |
| `r` / `b` | 重命名完整名称 / 仅基本文件名 |
| `m` / `c` | 输入目标路径移动 / 复制文件 |
| `x` / `y` / `p` | 剪切 / 复制 / 粘贴文件节点 |
| `d` | 删除文件或目录，会要求确认；不是删除 buffer |
| `Y` | 复制绝对路径到系统剪贴板 |
| `s` / `S` / `t` | 垂直分屏 / 水平分屏 / 新 tab 打开 |
| `P` | 切换预览 |
| `H` | 显示或隐藏隐藏文件 |
| `/` | 模糊查找节点 |
| `R` | 刷新 |
| `[g` / `]g` | 上一个 / 下一个 Git 修改文件 |
| `O` | 用系统默认应用打开 |
| `q` / `?` | 关闭树 / 查看该面板实际快捷键 |
| `Space b e` | 打开 buffer 树 |

Neo-tree 的移动和重命名事件接入了 `Snacks.rename`；是否更新 imports 取决于当前 LSP 的文件重命名能力。改完组件路径仍应检查引用和类型诊断。

### 3.3 Telescope 文件浏览器：先按 `sf`

你保留了第二套文件浏览器，它不会自动接管 `nvim .`。

| 浏览器普通模式按键 | 作用 |
|---|---|
| `Enter` | 进入目录 / 打开文件 |
| `N` | 新建文件或目录 |
| `h` | 上一级目录 |
| `/` | 进入输入模式开始搜索 |
| `Ctrl-y` | 在新 tab 打开选中路径 |
| `Ctrl-u` / `Ctrl-d` | 向上 / 下移动 10 项 |
| `PageUp` / `PageDown` | 滚动预览；你的默认配置关闭预览 |

## 4. 搜索、定位与浏览代码

### 4.1 项目搜索

| 按键 | 作用 |
|---|---|
| `Space /` / `Space s g` | 项目根目录全文搜索：fzf-lua |
| `Space s G` | cwd 全文搜索 |
| `;r` | Telescope 实时搜索，增加 `--hidden`，仍尊重 ignore |
| `Space s w` / `Space s W` | 搜索光标处单词：项目根 / cwd；V 模式搜索选中文字 |
| `Space s b` | 在当前 buffer 中模糊找行 |
| `Space s s` | 当前文件 LSP 符号列表 |
| `Space s S` | workspace 符号列表 |
| `;s` | Telescope Treesitter 符号列表，依赖对应解析器及插件支持 |
| `Space s R` | 恢复上次 fzf-lua 选择器 |
| `;;` | 恢复上次 Telescope 选择器 |
| `/文本` + Enter | 在当前文件向下查找 |
| `?文本` + Enter | 在当前文件向上查找 |
| `n` / `N` | 下一处 / 上一处搜索结果 |
| `*` / `#` | 搜索光标处单词 |
| `Esc` | 清除搜索高亮；插入模式同时退出插入 |
| `Space s j` / `Space s m` | 跳转历史 / 标记列表 |
| `Ctrl-o` / `Ctrl-i` | 跳回 / 跳前到历史位置 |
| `:行号` | 跳到指定行 |
| `gf` | 打开光标下的文件路径；模块别名解析优先用 `gd` |

### 4.2 两种搜索面板的内部按键不同

| 任务 | fzf-lua（`Space Space` / `Space /`） | Telescope（`;f` / `;r`） |
|---|---|---|
| 上下移动 | `Ctrl-p` / `Ctrl-n` 或方向键 | `Ctrl-p` / `Ctrl-n`，普通模式 `k` / `j` |
| 打开 | `Enter` | `Enter` |
| 垂直分屏打开 | `Ctrl-v` | `Ctrl-v` |
| 水平分屏打开 | `Ctrl-s` | `Ctrl-x` |
| 多选 | `Tab` / `Shift-Tab` | `Tab` / `Shift-Tab` |
| 关闭 | `Esc` | 输入模式 `Esc` 回普通模式，再 `Esc` 关闭 |
| 滚动预览 | `Ctrl-f` / `Ctrl-b` | `Ctrl-d` / `Ctrl-u`（普通文件选择器默认） |
| 隐藏文件开关 | `Alt-h`，适用于 files/grep | 当前自定义 `;f` 已包括隐藏文件 |
| ignore 开关 | `Alt-i`，适用于 files/grep | 需要明确传入 no_ignore，不要套用另一套配置 |
| 切换 Root/cwd | 文件动作中的 `Ctrl-r` / `Alt-c` | 自定义 `;f` 以 cwd 为起点 |
| 送到 Trouble | `Ctrl-t`，不是新 tab | `:Trouble` 或使用已确认的 picker 动作 |
| 将搜索结果送到 quickfix | `Ctrl-q` 选择全部并接受 | `Ctrl-q` 发送结果；具体 picker 可有覆盖 |

搜索窗口中的 `Ctrl-s` 是分屏，不是保存。`sf` 的普通模式又覆盖了 `Ctrl-u/d`，它们在文件浏览器里是移动 10 项。

### 4.3 快速移动、语法结构与折叠

| 按键 | 作用 |
|---|---|
| `h j k l` | 左下上右；你的 discipline 会提醒避免连续按同一个移动键 10 次 |
| `w` / `b` / `e` | 下一词开头 / 上一词开头 / 词尾 |
| `H` / `L` | 当前行首非空字符 / 行尾 |
| `0` / `^` / `$` | 绝对行首 / 非空行首 / 行尾 |
| `gg` / `G` | 文件头 / 文件尾 |
| `Ctrl-d` / `Ctrl-u` | 半页下 / 半页上 |
| `zz` | 将当前行放到窗口中央 |
| `%` | 匹配括号等结构 |
| `s` → 输入搜索文字 → 标签 | Flash 跳转；你设置的是匹配词首 |
| `S` | Flash Treesitter 结构选择 |
| `;jl` | 按行生成 Flash 跳转标签 |
| `sw` | Flash 跳转到诊断位置 |
| `Ctrl-Space`（N/V） | Treesitter 增量选择（当前由 Flash 集成提供；进入后 Ctrl-Space 扩大、Backspace 缩小） |
| `]f` / `[f` | 下一 / 上一函数起点 |
| `]F` / `[F` | 下一 / 上一函数终点 |
| `]c` / `[c` | 下一 / 上一 class 起点；语法映射覆盖 mini.bracketed 的同键注释跳转 |
| `]a` / `[a` | 下一 / 上一参数起点 |
| `]A` / `[A` | 下一 / 上一参数终点 |
| `za` / `zo` / `zc` | 切换 / 展开 / 折叠当前 fold |
| `zR` / `zM` | 展开 / 折叠全部 fold |

`ss`、`sv`、`sh` 等与单键 `s` 共用前缀；需要连续按。使用 `Space -` 或 `Space` 加 `\|` 分屏可避开这个前缀。

## 5. 编辑、选择、复制、批量修改

### 5.1 模式与基础操作

| 模式 | 按键 | 作用 |
|---|---|---|
| N | `i` / `a` | 光标前 / 后插入 |
| N | `I` / `A` | 行首 / 行尾插入 |
| N | `o` / `O` | 下方 / 上方新建一行并插入 |
| N | `Space o` / `Space O` | 下方 / 上方新行，不延续注释 |
| I | `jk` / `Esc` | 回普通模式 |
| N | `v` / `V` / `Ctrl-v` | 字符 / 整行 / 矩形块选择 |
| N | `Ctrl-a` | 全选文件；覆盖 Dial 的默认递增映射 |
| N | `u` / `Ctrl-r` | 撤销 / 重做 |
| N | `.` | 重复上次修改 |
| N | `yy` / `dd` | 复制 / 删除当前行 |
| N | `p` / `P` | 光标后 / 前粘贴 |
| N/V | `Space p` / `Space P` | 从复制寄存器 `0` 粘贴；V 模式只自定义了 `Space p` |
| N | `x` | 删除字符但不覆盖寄存器 |
| N/V | `Space d` / `Space D` | 使用黑洞寄存器删除，不覆盖已复制内容；N 下小写后接 motion |
| N/V | `Space c` / `Space C` | 使用黑洞寄存器修改；N 下小写后接 motion |
| N | `dw` | **自定义为向后选择并删除**，不是默认“向后面的词删除” |
| N | `de` / `daw` | 删除到词尾 / 删除整个词含相邻空白 |
| N | `J` | 合并当前行与下一行 |
| N | `+` / `-` | 原生数字加一 / 减一；受 discipline 连按限制 |
| N | `Ctrl-x` | Dial 递减：支持数字、布尔值、语义版本等 |
| N/V/I | `Ctrl-s` | 保存并回普通模式；面板内可能有局部覆盖 |
| N | `:wa` | 保存所有已命名且可写的修改文件 |
| N | `:q` / `:wq` | 关闭当前窗口 / 保存并关闭 |
| N | `Space q q` | 退出所有窗口；未保存内容会阻止退出 |

macOS 本地会话通常使用系统剪贴板。明确复制到系统剪贴板可用 `"+y`，明确粘贴用 `"+p`。终端的 Command-c/v 与 Vim 的寄存器不是一回事。

### 5.2 文本对象：先操作，再范围

`操作符 + 文本对象` 可以避免反复拖选。`i` 表示内部，`a` 表示包含外围结构。

| 组合 | 作用 |
|---|---|
| `ciw` | 修改当前词 |
| `di"` | 删除双引号中的内容，保留引号 |
| `ci(` | 修改圆括号内部 |
| `vi{` | 选择花括号内部 |
| `vat` / `vit` | 选择整个 HTML/JSX 标签结构 / 标签内部；依赖结构匹配 |
| `vaf` / `vif` | 选择整个函数 / 函数内部，依赖 Treesitter |
| `vac` / `vic` | 选择 class / class 内部 |
| `vaa` / `via` | 选择参数（含外围分隔）/ 参数内部 |
| `vie` | 选择 camelCase 等命名中的一段 |
| `vig` | 选择 buffer 文本对象 |
| `vih` | 选择当前 Git hunk，要求 Gitsigns 已附着 |
| `gv` | 重新选中上一段选择 |

### 5.3 注释、缩进与多处修改

| 按键 | 作用 |
|---|---|
| `gcc`（N） | 切换当前行注释 |
| `gc`（V） | 切换选中范围注释；TSX 使用上下文判断 |
| `gbc`（N） / `gb`（V） | 切换块注释 |
| `gco` / `gcO` / `gcA` | 在下方 / 上方 / 行尾插入注释 |
| `>>` / `<<` | 增加 / 减少当前行缩进 |
| `>` / `<`（V） | 缩进选择并保持选择 |
| `==` | 重新缩进当前行；不是 Prettier 格式化 |
| `Alt-j` / `Alt-k` | 向下 / 上移动行或选择 |
| `Ctrl-v` → 选块 → `I` → 输入 → `Esc` | 矩形范围批量插入 |
| `q` + 寄存器 → 操作 → `q` | 录制宏 |
| `@` + 寄存器 / `@@` | 执行宏 / 重复上次宏 |

你的配置没有专门的多光标插件，也没有启用 surround 插件；不要把 `Cmd-d` 或 `ys/cs/ds` 当成已配置功能。重复修改用 `.`、宏、块选择；语义统一改名用 LSP。

当前文件替换示例（逐个确认）：

```vim
:%s/oldName/newName/gc
```

### 5.4 项目批量替换：Grug Far

`Space s r` 打开替换面板；V 模式下入口同样可用。当前快捷键会按文件扩展名预填 Files Filter（例如 `*.tsx`），没有在映射中明确预填 Search；要跨 TS/TSX 文件替换，先调整过滤器。先检查 Search、Replacement、Files Filter 和匹配结果，再执行替换。

| 面板内 N 模式 | 作用 |
|---|---|
| `Tab` / `Shift-Tab` | 下一个 / 上一个输入区 |
| `\r` | 执行替换，会修改匹配文件 |
| `\q` | 将结果送入 quickfix |
| `Enter` | 跳到结果位置 |
| `\f` | 刷新搜索 |
| `\b` | 中止当前操作 |
| `\c` | 关闭面板 |
| `g?` | 查看当前面板帮助 |

这里 `\r` 是反斜杠再 r；`Space r` 是你的另一个快捷键。对变量改名优先 `Space c r`，文本替换无法理解引用关系。

## 6. TypeScript / React / Next.js / Node.js 智能功能

这些快捷键依赖当前 buffer 有合适的 LSP。没有服务附着时，部分键不会出现；用 `Space c l` 或 `:checkhealth vim.lsp` 检查。

| 模式 | 按键 | 作用 |
|---|---|---|
| N | `gd` | 跳定义：你自定义使用 Telescope，`reuse_win=false` |
| N | `gr` | 查找引用：当前默认使用 fzf-lua |
| N | `gI` | 跳实现 |
| N | `gy` | 跳类型定义 |
| N | `gD` | TS/JS 的 vtsls 跳源定义；其他 LSP 通常为声明 |
| N | `gR` | vtsls 查当前文件被引用的位置 |
| N | `K` | 查看类型、注释、悬停文档 |
| N | `gK` | 函数签名帮助 |
| I | `Ctrl-k` | 输入参数时显示函数签名 |
| N/V | `Space c a` | Code Action：快速修复、提取等，按服务提供的选项执行 |
| N | `Space c r` | 语义重命名变量、函数、组件 |
| N | `Space r n` | IncRename：输入新名字后 Enter；与 `Space r` 有前缀冲突 |
| N | `Space c R` | 文件重命名，并通知支持它的 LSP |
| N | `Space c o` | Organize Imports，服务支持该 source action 时出现 |
| N | `Space c M` | vtsls 补充缺失 imports |
| N | `Space c D` | vtsls 可自动修复的问题；不代表能消除所有 TS 类型错误 |
| N | `Space c V` | 选择 workspace TypeScript 版本 |
| N | `Space c A` | Source Action 列表 |
| N | `Space i` | 切换当前 buffer 的 inlay hints |
| N | `Space u h` | LazyVim/Snacks inlay hints 开关 |
| N | `[[` / `]]` | 上一 / 下一处当前符号高亮引用，依赖 documentHighlight 和 words 功能 |
| N | `Space c s` | **存在映射冲突**：本次运行时是 Trouble symbols；自定义还声明 SymbolsOutline |
| N | `Space c S` | Trouble 的 LSP 引用/定义面板 |
| V | `Space r` | refactoring.nvim 重构选择器，具体操作取决于语言和选择范围 |

生成 JSDoc/TSDoc 的自定义键是 `Space c c`，但支持 CodeLens 的 LSP 会用 buffer 映射覆盖成“运行 CodeLens”。**稳定的注释生成入口是 `:lua require("neogen").generate()`（可触发模块加载）；稳定的大纲入口是 `:SymbolsOutline`。** 本轮没有为了文档改动这些冲突。

React hooks、组件 props、Next.js route handler 和 Node.js 类型导航通常共用 vtsls。框架专属增强由项目依赖、TypeScript 配置和语言服务决定，不存在一组自动适用所有 Next.js 功能的额外按键。你的当前配置未专门启用 Prisma、数据库客户端或 HTTP 请求插件。

## 7. 补全、Snippets 与自动标签

当前主补全引擎是 **nvim-cmp**，片段引擎是 **LuaSnip**；不要套用 blink.cmp 快捷键。

| I / snippet 模式按键 | 作用 |
|---|---|
| `Ctrl-Space` | 手动触发补全 |
| `Ctrl-n` / `Ctrl-p` | 下一 / 上一候选 |
| `Ctrl-y` | 确认候选；未手选时也允许确认首个候选 |
| `Ctrl-e` | 中止补全 |
| `Ctrl-f` / `Ctrl-b` | 滚动补全文档；没有补全文档时可能由 Noice 接管 |
| `Tab` | 可展开 LuaSnip 时展开，否则跳到下一占位；不满足条件时回退普通 Tab |
| `Shift-Tab` | 回到上一 LuaSnip 占位，要求有可跳转片段 |
| `Esc` | 退出插入 / 停止当前片段交互 |
| `Enter` | **你的自定义换行与标签处理，不保证接受补全** |

你的 HTML 自定义片段包括 `div`、`p`、`span`，另有 friendly-snippets。自定义 HTML 片段只明确注册在 HTML filetype，不能直接保证所有 TSX buffer 都有同一触发词。

HTML/JSX 关闭标签与成对括号通常自动处理，无须专门触发键。macOS 的 `Ctrl-Space` 可能先被输入法快捷键拦截；这时是系统按键冲突，可从自动补全菜单使用 `Ctrl-n` / `Ctrl-y`。

## 8. 保存、格式化、Lint 与诊断

| 按键 / 命令 | 作用 |
|---|---|
| `Ctrl-s` / `:w` | 保存；启用 autoformat 时自动格式化 |
| `Space c f`（N/V） | 按 LazyVim 格式化策略格式化文件 / 选择范围 |
| `Space f m` | 自定义 Conform 异步格式化，必要时回退 LSP |
| `Space c F` | 格式化嵌入语言区域，是否支持由 formatter 决定 |
| `Space u f` | 全局自动格式化开关 |
| `Space u F` | 当前 buffer 自动格式化开关 / 覆盖 |
| `Space c d` | 显示当前位置诊断详情 |
| `Ctrl-j` | 自定义：跳下一条诊断并弹出详情 |
| `[d` / `]d` | 上一 / 下一条诊断 |
| `[e` / `]e` | 上一 / 下一条 error |
| `[w` / `]w` | 上一 / 下一条 warning |
| `Space x x` / `Space x X` | 全部 / 当前 buffer 诊断面板 |
| `Space s d` / `Space s D` | fzf-lua workspace / 当前文档诊断 |
| `;e` | Telescope 诊断 |
| `Space u d` | 切换诊断显示；不等于关闭 LSP 检查 |
| `:ConformInfo` | 当前 formatter、可用性、日志位置 |
| `:LintInfo` | nvim-lint 信息；若此版本没有该命令，用 `:lua print(vim.inspect(require('lint').linters_by_ft))` |
| `Space c l` | LSP 配置/状态 |
| `Space c m` / `:Mason` | 管理语言服务器和工具 |

你的 prettier、eslint extras 已声明，但 formatter 与诊断来源最终还受项目配置、工具安装、LSP 和文件类型影响。**不能把所有诊断都当作 ESLint，也不能把一次保存等同于运行整个项目的 lint/test/build。**

Trouble 面板通常用 `j/k` 选项、`Enter` 跳转、`q` 关闭、`?` 查帮助。`[q` / `]q` 在 Trouble 打开时前后跳项目，否则前后跳 quickfix。

## 9. 分屏、Tab 与终端

### 9.1 编辑布局

| 按键 | 作用 |
|---|---|
| `sv` / `Space` 加 `\|` | 垂直分屏：代码左右摆放 |
| `ss` / `Space -` | 水平分屏：上下摆放 |
| `sh` / `sj` / `sk` / `sl` | 切换到左 / 下 / 上 / 右窗口 |
| `Ctrl-h` / `Ctrl-k` / `Ctrl-l` | 切到左 / 上 / 右窗口 |
| `Ctrl-w j` | 切到下窗口；你的 `Ctrl-j` 已用于诊断 |
| `Ctrl-w =` | 均分窗口尺寸 |
| `Ctrl` + 方向键 | 调整尺寸，每次 2 行/列 |
| `Ctrl-w` 再方向键 | 你的自定义尺寸调整；是先按 Ctrl-w，再按方向键 |
| `Space w d` / `Ctrl-w c` | 关闭当前窗口 |
| `Space w m` / `Space u Z` | 最大化当前窗口，再按恢复 |
| `Space z` | zen-mode.nvim 专注模式 |
| `Space u z` | Snacks Zen 模式，和上一项是不同实现 |
| `te` | 进入 `:tabedit` 命令行；输入空格和路径再 Enter |
| `Tab` / `Shift-Tab`（N） | 下一 / 上一 tab |
| `Space Tab Tab` | 新建 tab |
| `Space Tab d` | 关闭当前 tab |
| `Space Tab o` | 关闭其他 tab |
| `Space Tab f` / `Space Tab l` | 第一个 / 最后一个 tab |
| `Space Tab [` / `Space Tab ]` | 前一个 / 后一个 tab |

### 9.2 开发服务器、日志与命令

| 按键 / 命令 | 作用 |
|---|---|
| `Space f t` | 打开/切换项目根目录浮动终端 |
| `Space f T` | 打开/切换 cwd 浮动终端 |
| `Ctrl-/` | 显示/隐藏或聚焦项目终端；部分终端发送等价的 `Ctrl-_` |
| `:vsplit` 后 `:terminal` | 新建独立侧边终端，适合 dev server |
| `:split` 后 `:terminal` | 新建独立下方终端，适合测试或日志 |
| `Ctrl-\` 然后 `Ctrl-n`（T） | 离开终端输入，回 Terminal-Normal，可以滚动日志 |
| `i`（终端 buffer 的 N） | 回到终端输入 |
| `Ctrl-c`（T） | 中断当前运行进程，例如 dev server |
| `exit`（T） | 结束 shell；隐藏窗口并不等于停止进程 |

开发服务占用一个终端后，用另一个终端跑检查。下列是流程示例；以项目 `package.json` 中实际存在的 scripts 为准，不要混用 pnpm/npm/yarn 的锁文件。

```sh
# 终端 A：开发服务器
npm run dev

# 终端 B：检查、测试与构建，按项目提供的 scripts 执行
npm run lint
npm run typecheck
npm test
npm run build

# Node.js API 联调：按项目实际路由调整
curl -i http://localhost:3000/api/health
```

**当前没有启用 DAP 和 neotest extras**，因此没有可直接承诺的 F5 调试、断点、单测运行或覆盖率快捷键。用终端测试脚本；Node 调试可按项目脚本开启 inspector，再由浏览器开发工具连接。不要将 `Space d…` 的 profiler 映射误认成应用调试器。

## 10. Git：查看变化 → 暂存 → 提交 → 推送 → PR

### 10.1 编辑区中的 Git 快捷键

Gitsigns 键只在它已附着的 Git 文件 buffer 生效；新文件或项目外文件可能暂时没有对应映射。

| 按键 | 作用 |
|---|---|
| `Space g s` | fzf-lua Git status |
| `Space g e` | Neo-tree Git status 面板 |
| `]h` / `[h` | 下一 / 上一 hunk（连续修改块） |
| `]H` / `[H` | 最后 / 第一个 hunk |
| `Space g h p` | 预览当前 hunk 的增删 |
| `Space g h s`（N/V） | 暂存当前 hunk / 选择的行 |
| `Space g h u` | 撤销上次 hunk 暂存 |
| `Space g h S` | 暂存当前文件 |
| `Space g h r`（N/V） | **丢弃**当前 hunk / 选择行的未暂存修改 |
| `Space g h R` | **丢弃**当前文件的未暂存修改 |
| `Space g h d` | 与 index 比较当前文件 |
| `Space g h D` | 与 `~`（通常 HEAD 的父提交）比较当前文件 |
| `Space g h b` | 查看当前行完整 blame |
| `Space g h B` | Gitsigns 整文件 blame |
| `Space g b` | 本次真实终端映射为 Snacks 当前行 Git 历史；和 git.nvim 的 blame 声明冲突 |
| `Space g l` / `Space g c` | fzf-lua 提交历史 |
| `Space g L` | Snacks 的 cwd 提交历史 |
| `Space g f` | 当前文件历史 |
| `Space g S` | stash 列表 |
| `Space g B`（N/V） | 在网页打开文件 / 所选行 |
| `Space g Y`（N/V） | 复制文件 / 所选行网页链接 |
| `Space g o`（N/V） | git.nvim 的浏览器打开功能 |
| `Space u G` | 切换 Git gutter signs |

`Space g h r` 和 `Space g h R` 是丢弃代码，**不是 unstage**。要撤销暂存用 `Space g h u` 或 `git restore --staged`。

### 10.2 Neo-tree Git 面板内的完整操作

先按 `Space g e`，再在这个面板中操作；以下组合**没有前导 Space**。

| 面板内按键 | 作用 |
|---|---|
| `j/k`、`Enter` | 选择并打开修改文件 |
| `ga` | 暂存所选文件 |
| `gu` | 取消所选文件暂存 |
| `gt` | 切换所选文件暂存状态 |
| `A` | 暂存所有变化，先确认列表没有无关文件 |
| `gc` | 提交：按弹窗提示输入 commit message |
| `gp` | 推送到远端，需要远端、认证及合适的 upstream |
| `gg` | 提交并推送，属于写远端操作 |
| `gr` | 丢弃所选文件变化，不是代码引用查询 |
| `gU` | 执行 `git reset --soft HEAD~1`，保留暂存内容；先确认提交是否已经发布 |
| `R` / `q` / `?` | 刷新 / 关闭 / 查看实际键表 |

本轮只核对源码和映射，**没有实际提交、推送、回滚或创建 PR**。提交前先在编辑器 `:wa`，Git 处理的是磁盘内容和 index，尚未保存的 buffer 不会自动包含在提交里。

### 10.3 git.nvim 的其他键：特别注意 `gp` 不是 push

| 编辑区按键 | 当前声明的作用 |
|---|---|
| `Space g d` | git.nvim diff 窗口 |
| `Space g D` | 关闭该 diff 窗口 |
| `Space g p` | 在浏览器打开当前分支相关 PR；**不是推送** |
| `Space g n` | 打开创建 PR 的网页流程；不等于已发布 PR |
| `Space g r` | 打开提交列表，确认后执行 `git revert --no-commit` |
| `Space g R` | 针对当前文件，反向应用所选提交补丁 |
| `:lua require("git.blame").blame()` | 明确打开 git.nvim blame，不依赖冲突中的 `Space g b` |

在 git.nvim 的 blame 窗口，`Enter` 看对应提交，`q` 关闭。revert 列表的 `Enter` 会实际应用反向修改，不应当成普通“查看历史”。

### 10.4 没有 lazygit 时，终端工作流仍然完整

本机核对结果：`lazygit` 不在 PATH。因此 LazyVim 的 `Space g g` / `Space g G` **当前不会注册**，不要把它们当成可用快捷键。无需安装 lazygit 才能提交代码。

以下命令是开发流程示例，不会由这份文档自动执行。`main`、分支名和文件路径要按实际项目调整。

```sh
# 开始开发：查看状态，创建功能分支
git status --short
git switch -c feat/profile-page

# 开发完成：先在 Neovim 保存，再审查差异
git diff
git add path/to/changed-file.tsx
git diff --cached
git commit -m "feat: add profile page"
git push -u origin HEAD
```

| Git 任务 | 在终端执行 |
|---|---|
| 列出本地与远端分支 | `git branch -a` |
| 切换已有分支 | `git switch branch-name` |
| 获取远端信息，不合并 | `git fetch origin` |
| 只允许快进方式更新当前分支 | `git pull --ff-only` |
| 交互式暂存部分变化 | `git add -p` |
| 取消文件暂存，保留工作区修改 | `git restore --staged path/to/file` |
| 查看提交图 | `git log --oneline --graph --decorate -20` |
| 暂存工作现场，含未跟踪文件 | `git stash push -u -m "wip"` |
| 查看 stash | `git stash list` |
| 恢复最近 stash 并保留记录 | `git stash apply` |
| 处理确认完毕后删除最近 stash | `git stash drop` |
| 比较当前分支与基准分支 | `git diff origin/main...HEAD` |

### 10.5 合并冲突

先用 `git status` 确认冲突文件，打开后使用 `]x` / `[x` 跳转冲突标记（mini.bracketed）。手动整理要保留的代码，删除 `<<<<<<<`、`=======`、`>>>>>>>` 标记，保存后重新跑检查。

```sh
git add path/to/resolved-file
# 仅执行与你正在进行的操作对应的一条：
git merge --continue
# 或：git rebase --continue
```

这里没有配置专门的 Git 三方冲突合并 UI。Avante 的 `co/ct/cb` 是它自己的 AI diff 操作，不能当成全局通用的 Git 冲突解决快捷键。普通 diff 窗口可以用 `:diffoff!` 结束 diff 显示。

## 11. AI 辅助：Copilot 与 Avante

这部分需要对应账号/服务可用；本轮没有发送 AI 请求或验证鉴权。

Copilot 当前作为 nvim-cmp 来源：用 `Ctrl-n/p` 选中 Copilot 候选、`Ctrl-y` 接受。你的自定义 Tab 优先 LuaSnip，不能照搬“Tab 一定接受 AI 建议”的教程。`:Copilot status` 查看状态，`:Copilot auth` 进入认证。

| 按键 | Avante 作用 |
|---|---|
| `Space a a`（N/V） | 提问，可使用选择范围作上下文 |
| `Space a n` | 新对话 |
| `Space a e`（V） | 针对选择范围请求修改 |
| `Space a t` / `Space a f` | 切换 / 聚焦侧栏 |
| `Space a S` | 停止生成 |
| `Space a r` | 刷新 |
| `Space a ?` / `Space a h` | 选择模型 / 历史 |
| `Space a B` | 添加已打开 buffers 到上下文 |
| 侧栏输入 I：`Ctrl-s` | 发送请求，**不是保存代码文件** |
| 侧栏 N：`Enter` | 发送请求 |
| 侧栏 N：`a` / `A` | 应用光标处 / 所有建议，可能修改文件 |
| 侧栏 N：`q` | 关闭侧栏 |

## 12. 工作现场、界面与排查

| 按键 / 命令 | 作用 |
|---|---|
| `Space q s` | 恢复当前目录会话 |
| `Space q l` | 恢复最近会话 |
| `Space q S` | 选择会话 |
| `Space q d` | 本次会话不保存 |
| `Space u w` | 自动换行开关 |
| `Space u l` / `Space u L` | 行号 / 相对行号开关 |
| `Space u g` | 缩进参考线开关 |
| `Space u T` | Treesitter 高亮开关 |
| `Space u s` | 拼写检查开关 |
| `Space u C` | 选择主题 |
| `Space r`（N） | 将当前行六位 HEX 颜色转换为 HSL；输出格式来自个人脚本，使用前检查是否符合目标 CSS 语法 |
| `Space .` / `Space S` | 临时 scratch buffer / 选择 scratch |
| `Space n` | 通知历史 |
| `Space s n a` | 查看全部 Noice 消息 |
| `Space s n l` / `Space s n h` | 最后一条消息 / 消息历史 |
| `Space s n d` / `Space u n` | 清除当前消息显示 |
| `Space l` | Lazy 插件管理器 |
| `Space ?` | 当前 buffer 快捷键帮助 |
| `Space s k` | 搜索快捷键 |
| `Space s C` | 搜索可用命令 |
| `Space :` | 命令历史 |
| `Space s h` / `;t` | 帮助文档 |
| `Space x q` / `Space x l` | quickfix / location list |
| `Space x Q` / `Space x L` | Trouble 形式的 quickfix / location list |
| `]t` / `[t` | 下一个 / 上一个 TODO 注释 |
| `Space s t` / `Space x t` | 搜索 TODO / Trouble TODO 面板 |
| `:messages` | 查看启动和运行消息 |
| `:checkhealth` | 健康检查 |
| `:LazyExtras` | 查看可选功能；启用后才有其相关快捷键 |
| `:TSUpdate` | 更新解析器，不是每天开发必做步骤 |

查看某个按键到底被谁设置：

```vim
:verbose nmap <leader>cs
:verbose nmap <leader>gb
:verbose imap <CR>
```

## 13. 当前配置的覆盖与限制：以这张表为准

| 按键 / 功能 | 容易误会的行为 | 当前事实与稳定替代 |
|---|---|---|
| `H/L` | 上下 buffer | 自定义为行首/行尾；文件切换用 `[b`、`]b` |
| `Ctrl-j` | 下方窗口 | 下一条诊断；下窗口用 `sj` |
| `Ctrl-a`（N） | Dial 递增 | 全选；数字用 `+`，扩展类型递增不能假定已绑定 |
| `dw` | 删除后面的词 | 自定义向后删除；标准删除用 `de` / `daw` |
| Enter（I） | 接受补全 | 当前被自定义换行覆盖；用 `Ctrl-y` |
| Tab（N/I/选择器） | 一个通用动作 | tab 页切换 / snippet / 多选，按上下文区分 |
| `Space c c` | 总是生成文档注释 | CodeLens buffer 映射可覆盖；注释用 `:lua require("neogen").generate()` |
| `Space c s` | 总是 SymbolsOutline | 与 Trouble 重复声明；本次运行时为 Trouble；指定使用命令 |
| `Space g b` | 总是 git.nvim blame | 本次真实终端是 Snacks 行历史；整文件 blame 用 `Space g h B` 或 `:lua require("git.blame").blame()` |
| `Space g p` | push | git.nvim 打开 PR；Neo-tree Git 面板内无 Space 的 `gp` 才是推送 |
| `Space r` | 一个固定动作 | N：颜色转换；V：重构；`Space r n`：IncRename |
| 默认搜索 | 全都是 Telescope | `Space` 默认走 fzf-lua，自定义 `;…` 走 Telescope，`gd` 也显式走 Telescope |
| `Space g g` | lazygit | 可执行文件缺失，当前无此映射 |
| `Space t…` / F5 / 断点 | IDE 测试、调试 | 未启用 neotest/DAP；使用终端或外部调试器 |
| 顶部 bufferline 固定/关闭键 | 都是安全的文件标签操作 | 你使用 tabs 模式，`Space b p/bP/br/bl/bj` 虽有声明，不把它们当通用 buffer 管理；优先用第 3、9 节的明确操作 |

运行时结果还受文件类型、服务能力、加载先后和面板局部映射影响。附录列出本次 Lua 与 TypeScript 场景捕获的映射；不是承诺每个文件始终拥有同一组键。未逐项执行删除、推送、AI 改写等操作。

## 14. 一个完整开发流程

| 阶段 | 连贯操作 |
|---|---|
| 开始 | 项目根目录 `nvim .` → `Space q s` 恢复现场，或 `Space e` 浏览 |
| 建分支 | `Space f t` → `git status --short` → `git switch -c feat/profile-page` |
| 找入口 | `Space Space` 找页面或 route handler → `Space /` 搜 API/组件名 |
| 读调用链 | `gd` → `K` → `gr` → `Ctrl-o` 回来 |
| 编写 | `i` → `Ctrl-n/p` 选补全 → `Ctrl-y` 接受 → `Tab` 跳片段 → `jk` |
| 修正 | `Space c a` → `Space c M` 补 imports → `Space c o` 整理 imports |
| 重构 | `Space c r` 语义改名；移动文件用树内 `r/m`，检查引用 |
| 检查 | `Ctrl-s` → `Space x x` 看诊断 → 终端执行项目 lint/typecheck/test |
| 联调 | 独立终端跑 dev server → 浏览器检查页面，终端查看 Node 日志 |
| 审查 | `Space g s` → `]h` → `Space g h p` 查看每块差异 |
| 暂存 | `Space g h s` 分块暂存，或 Git 树 `ga` 暂存文件 |
| 提交 | 终端 `git diff --cached` → `git commit` → `git push -u origin HEAD` |
| PR | `Space g n` 打开网页创建 PR，检查描述、diff 和 CI |
| 收工 | `:wa` 保存 → 终端 `Ctrl-c` 停服务 → `Space q q` 退出 |

## 15. 核对来源

- 当前个人配置：`lua/config/keymaps.lua`、`lua/config/lazy.lua`、`lua/config/options.lua`、`lua/plugins/*.lua`、`lua/craftzdog/*.lua`。
- 已安装 LazyVim：`lua/lazyvim/config/keymaps.lua`、`plugins/lsp/init.lua`、`plugins/editor.lua`、`plugins/treesitter.lua`、`extras/editor/fzf.lua`、`extras/editor/neo-tree.lua`、`extras/coding/nvim-cmp.lua`、`extras/coding/luasnip.lua`、`extras/lang/typescript/vtsls.lua`。
- 插件内部面板映射：Neo-tree defaults、fzf-lua defaults、Telescope、git.nvim config、Grug Far opts、Avante config。
- 在实际终端中打开 Lua 与临时 TypeScript 项目，分别导出全局和 buffer-local 映射；TypeScript 场景进入插入模式核对补全覆盖；未依赖 headless 的默认映射来判断用户键。


## 16. 运行时快捷键索引

以下是普通代码 buffer 的**显式映射**，不包括全部 Vim 内建命令、插件内部 `<Plug>` 动作或尚未打开的面板局部按键。Lazy 延迟加载入口也可能显示在索引中；出现映射不代表依赖和远端服务已经验证。已合并 Lua/TypeScript 两种场景；buffer 映射优先于同键全局映射。

按键栏以 `<Space>` 表示空格，`<C-…>` 表示 Ctrl，`<M-…>` 表示 Alt。摘要保留插件原始描述，正文提供中文操作说明。

### 16.1 普通模式 N

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `<Space><Space>` | 全局；Lua/TypeScript | Find Files (Root Dir) |
| `<Space>,` | 全局；Lua/TypeScript | Switch Buffer |
| `<Space>-` | 全局；Lua/TypeScript | Split Window Below |
| `<Space>.` | 全局；Lua/TypeScript | Toggle Scratch Buffer |
| `<Space>/` | 全局；Lua/TypeScript | Grep (Root Dir) |
| `<Space>:` | 全局；Lua/TypeScript | Command History |
| `<Space><Tab><Tab>` | 全局；Lua/TypeScript | New Tab |
| `<Space><Tab>[` | 全局；Lua/TypeScript | Previous Tab |
| `<Space><Tab>]` | 全局；Lua/TypeScript | Next Tab |
| `<Space><Tab>d` | 全局；Lua/TypeScript | Close Tab |
| `<Space><Tab>f` | 全局；Lua/TypeScript | First Tab |
| `<Space><Tab>l` | 全局；Lua/TypeScript | Last Tab |
| `<Space><Tab>o` | 全局；Lua/TypeScript | Close Other Tabs |
| `<Space>?` | 全局；Lua/TypeScript | Buffer Keymaps (which-key) |
| `<Space>C` | 全局；Lua/TypeScript | "_C |
| `<Space>D` | 全局；Lua/TypeScript | "_D |
| `<Space>E` | 全局；Lua/TypeScript | Explorer NeoTree (cwd) |
| `<Space>K` | 全局；Lua/TypeScript | Keywordprg |
| `<Space>L` | 全局；Lua/TypeScript | LazyVim Changelog |
| `<Space>O` | 全局；Lua/TypeScript | O<Esc>^Da |
| `<Space>P` | 全局；Lua/TypeScript | "0P |
| `<Space>S` | 全局；Lua/TypeScript | Select Scratch Buffer |
| `<Space>&#96;` | 全局；Lua/TypeScript | Switch to Other Buffer |
| `<Space>a?` | 全局；Lua/TypeScript | avante: select model |
| `<Space>aB` | 全局；Lua/TypeScript | avante: add all open buffers |
| `<Space>aC` | 全局；Lua/TypeScript | avante: toggle selection |
| `<Space>aM` | 全局；Lua/TypeScript | avante: select ACP model |
| `<Space>aR` | 全局；Lua/TypeScript | avante: display repo map |
| `<Space>aS` | 全局；Lua/TypeScript | avante: stop |
| `<Space>aa` | 全局；Lua/TypeScript | avante: ask |
| `<Space>ad` | 全局；Lua/TypeScript | avante: toggle debug |
| `<Space>af` | 全局；Lua/TypeScript | avante: focus |
| `<Space>ah` | 全局；Lua/TypeScript | avante: select history |
| `<Space>am` | 全局；Lua/TypeScript | avante: select ACP mode |
| `<Space>an` | 全局；Lua/TypeScript | avante: create new ask |
| `<Space>ar` | 全局；Lua/TypeScript | avante: refresh |
| `<Space>as` | 全局；Lua/TypeScript | avante: toggle suggestion |
| `<Space>at` | 全局；Lua/TypeScript | avante: toggle |
| `<Space>az` | 全局；Lua/TypeScript | avante: toggle Zen Mode |
| `<Space>bD` | 全局；Lua/TypeScript | Delete Buffer and Window |
| `<Space>bP` | 全局；Lua/TypeScript | Delete Non-Pinned Buffers |
| `<Space>bb` | 全局；Lua/TypeScript | Switch to Other Buffer |
| `<Space>bd` | 全局；Lua/TypeScript | Delete Buffer |
| `<Space>be` | 全局；Lua/TypeScript | Buffer Explorer |
| `<Space>bi` | 全局；Lua/TypeScript | Delete Invisible Buffers |
| `<Space>bj` | 全局；Lua/TypeScript | Pick Buffer |
| `<Space>bl` | 全局；Lua/TypeScript | Delete Buffers to the Left |
| `<Space>bo` | 全局；Lua/TypeScript | Delete Other Buffers |
| `<Space>bp` | 全局；Lua/TypeScript | Toggle Pin |
| `<Space>br` | 全局；Lua/TypeScript | Delete Buffers to the Right |
| `<Space>c` | 全局；Lua/TypeScript | "_c |
| `<Space>cA` | buffer；Lua/TypeScript | Source Action |
| `<Space>cC` | buffer；Lua/TypeScript | Refresh & Display Codelens |
| `<Space>cD` | buffer；TypeScript | Fix all diagnostics |
| `<Space>cF` | 全局；Lua/TypeScript | Format Injected Langs |
| `<Space>cM` | buffer；TypeScript | Add missing imports |
| `<Space>cR` | buffer；Lua/TypeScript | Rename File |
| `<Space>cS` | 全局；Lua/TypeScript | LSP references/definitions/... (Trouble) |
| `<Space>cV` | buffer；TypeScript | Select TS workspace version |
| `<Space>ca` | buffer；Lua/TypeScript | Code Action |
| `<Space>cc` | buffer；Lua/TypeScript | Run Codelens |
| `<Space>cc` | 全局；Lua/TypeScript | neogen comment |
| `<Space>cd` | 全局；Lua/TypeScript | Line Diagnostics |
| `<Space>cf` | 全局；Lua/TypeScript | Format |
| `<Space>cl` | buffer；Lua/TypeScript | Lsp Info |
| `<Space>cm` | 全局；Lua/TypeScript | Mason |
| `<Space>co` | buffer；TypeScript | Organize Imports |
| `<Space>cr` | buffer；Lua/TypeScript | Rename |
| `<Space>cs` | 全局；Lua/TypeScript | Symbols (Trouble) |
| `<Space>d` | 全局；Lua/TypeScript | "_d |
| `<Space>dph` | 全局；Lua/TypeScript | Toggle Profiler Highlights |
| `<Space>dpp` | 全局；Lua/TypeScript | Toggle Profiler |
| `<Space>dps` | 全局；Lua/TypeScript | Profiler Scratch Buffer |
| `<Space>e` | 全局；Lua/TypeScript | Explorer NeoTree (Root Dir) |
| `<Space>fB` | 全局；Lua/TypeScript | Buffers (all) |
| `<Space>fE` | 全局；Lua/TypeScript | Explorer NeoTree (cwd) |
| `<Space>fF` | 全局；Lua/TypeScript | Find Files (cwd) |
| `<Space>fP` | 全局；Lua/TypeScript | Find Plugin File |
| `<Space>fR` | 全局；Lua/TypeScript | Recent (cwd) |
| `<Space>fT` | 全局；Lua/TypeScript | Terminal (cwd) |
| `<Space>fb` | 全局；Lua/TypeScript | Buffers |
| `<Space>fc` | 全局；Lua/TypeScript | Find Config File |
| `<Space>fe` | 全局；Lua/TypeScript | Explorer NeoTree (Root Dir) |
| `<Space>ff` | 全局；Lua/TypeScript | Find Files (Root Dir) |
| `<Space>fg` | 全局；Lua/TypeScript | Find Files (git-files) |
| `<Space>fm` | 全局；Lua/TypeScript | Format buffer |
| `<Space>fn` | 全局；Lua/TypeScript | New File |
| `<Space>fr` | 全局；Lua/TypeScript | Recent |
| `<Space>ft` | 全局；Lua/TypeScript | Terminal (Root Dir) |
| `<Space>gB` | 全局；Lua/TypeScript | Git Browse (open) |
| `<Space>gD` | 全局；Lua/TypeScript | <Cmd>lua require('git.diff').close()<CR> |
| `<Space>gL` | 全局；Lua/TypeScript | Git Log (cwd) |
| `<Space>gR` | 全局；Lua/TypeScript | <Cmd>lua require('git.revert').open(true)<CR> |
| `<Space>gS` | 全局；Lua/TypeScript | Git Stash |
| `<Space>gY` | 全局；Lua/TypeScript | Git Browse (copy) |
| `<Space>gb` | 全局；Lua/TypeScript | Git Blame Line |
| `<Space>gc` | 全局；Lua/TypeScript | Commits |
| `<Space>gd` | 全局；Lua/TypeScript | <Cmd>lua require('git.diff').open()<CR> |
| `<Space>ge` | 全局；Lua/TypeScript | Git Explorer |
| `<Space>gf` | 全局；Lua/TypeScript | Git Current File History |
| `<Space>ghB` | buffer；Lua | Blame Buffer |
| `<Space>ghD` | buffer；Lua | Diff This ~ |
| `<Space>ghR` | buffer；Lua | Reset Buffer |
| `<Space>ghS` | buffer；Lua | Stage Buffer |
| `<Space>ghb` | buffer；Lua | Blame Line |
| `<Space>ghd` | buffer；Lua | Diff This |
| `<Space>ghp` | buffer；Lua | Preview Hunk Inline |
| `<Space>ghr` | buffer；Lua | Reset Hunk |
| `<Space>ghs` | buffer；Lua | Stage Hunk |
| `<Space>ghu` | buffer；Lua | Undo Stage Hunk |
| `<Space>gl` | 全局；Lua/TypeScript | Commits |
| `<Space>gn` | 全局；Lua/TypeScript | <Cmd>lua require('git.browse').create_pull_request()<CR> |
| `<Space>go` | 全局；Lua/TypeScript | <Cmd>lua require('git.browse').open(false)<CR> |
| `<Space>gp` | 全局；Lua/TypeScript | <Cmd>lua require('git.browse').pull_request()<CR> |
| `<Space>gr` | 全局；Lua/TypeScript | <Cmd>lua require('git.revert').open(false)<CR> |
| `<Space>gs` | 全局；Lua/TypeScript | Status |
| `<Space>i` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<Space>l` | 全局；Lua/TypeScript | Lazy |
| `<Space>n` | 全局；Lua/TypeScript | Notification History |
| `<Space>o` | 全局；Lua/TypeScript | o<Esc>^Da |
| `<Space>p` | 全局；Lua/TypeScript | "0p |
| `<Space>qS` | 全局；Lua/TypeScript | Select Session |
| `<Space>qd` | 全局；Lua/TypeScript | Don't Save Current Session |
| `<Space>ql` | 全局；Lua/TypeScript | Restore Last Session |
| `<Space>qq` | 全局；Lua/TypeScript | Quit All |
| `<Space>qs` | 全局；Lua/TypeScript | Restore Session |
| `<Space>r` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<Space>rn` | 全局；Lua/TypeScript | Rename |
| `<Space>s"` | 全局；Lua/TypeScript | Registers |
| `<Space>s/` | 全局；Lua/TypeScript | Search History |
| `<Space>sC` | 全局；Lua/TypeScript | Commands |
| `<Space>sD` | 全局；Lua/TypeScript | Buffer Diagnostics |
| `<Space>sG` | 全局；Lua/TypeScript | Grep (cwd) |
| `<Space>sH` | 全局；Lua/TypeScript | Search Highlight Groups |
| `<Space>sM` | 全局；Lua/TypeScript | Man Pages |
| `<Space>sR` | 全局；Lua/TypeScript | Resume |
| `<Space>sS` | 全局；Lua/TypeScript | Goto Symbol (Workspace) |
| `<Space>sT` | 全局；Lua/TypeScript | Todo/Fix/Fixme |
| `<Space>sW` | 全局；Lua/TypeScript | Word (cwd) |
| `<Space>sa` | 全局；Lua/TypeScript | Auto Commands |
| `<Space>sb` | 全局；Lua/TypeScript | Buffer Lines |
| `<Space>sc` | 全局；Lua/TypeScript | Command History |
| `<Space>sd` | 全局；Lua/TypeScript | Diagnostics |
| `<Space>sg` | 全局；Lua/TypeScript | Grep (Root Dir) |
| `<Space>sh` | 全局；Lua/TypeScript | Help Pages |
| `<Space>sj` | 全局；Lua/TypeScript | Jumplist |
| `<Space>sk` | 全局；Lua/TypeScript | Key Maps |
| `<Space>sl` | 全局；Lua/TypeScript | Location List |
| `<Space>sm` | 全局；Lua/TypeScript | Jump to Mark |
| `<Space>sn` | 全局；Lua/TypeScript | +noice |
| `<Space>sna` | 全局；Lua/TypeScript | Noice All |
| `<Space>snd` | 全局；Lua/TypeScript | Dismiss All |
| `<Space>snh` | 全局；Lua/TypeScript | Noice History |
| `<Space>snl` | 全局；Lua/TypeScript | Noice Last Message |
| `<Space>snt` | 全局；Lua/TypeScript | Noice Picker (Telescope/FzfLua) |
| `<Space>sq` | 全局；Lua/TypeScript | Quickfix List |
| `<Space>sr` | 全局；Lua/TypeScript | Search and Replace |
| `<Space>ss` | 全局；Lua/TypeScript | Goto Symbol |
| `<Space>st` | 全局；Lua/TypeScript | Todo |
| `<Space>sw` | 全局；Lua/TypeScript | Word (Root Dir) |
| `<Space>uA` | 全局；Lua/TypeScript | Toggle Tabline |
| `<Space>uC` | 全局；Lua/TypeScript | Colorscheme with Preview |
| `<Space>uD` | 全局；Lua/TypeScript | Toggle Dimming |
| `<Space>uF` | 全局；Lua/TypeScript | Toggle Auto Format (Buffer) |
| `<Space>uG` | 全局；Lua/TypeScript | Toggle Git Signs |
| `<Space>uI` | 全局；Lua/TypeScript | Inspect Tree |
| `<Space>uL` | 全局；Lua/TypeScript | Toggle Relative Number |
| `<Space>uS` | 全局；Lua/TypeScript | Toggle Smooth Scroll |
| `<Space>uT` | 全局；Lua/TypeScript | Toggle Treesitter Highlight |
| `<Space>uZ` | 全局；Lua/TypeScript | Toggle Zoom Mode |
| `<Space>ua` | 全局；Lua/TypeScript | Toggle Animations |
| `<Space>ub` | 全局；Lua/TypeScript | Toggle Dark Background |
| `<Space>uc` | 全局；Lua/TypeScript | Toggle Conceal Level |
| `<Space>ud` | 全局；Lua/TypeScript | Toggle Diagnostics |
| `<Space>uf` | 全局；Lua/TypeScript | Toggle Auto Format (Global) |
| `<Space>ug` | 全局；Lua/TypeScript | Toggle Indent Guides |
| `<Space>uh` | 全局；Lua/TypeScript | Toggle Inlay Hints |
| `<Space>ui` | 全局；Lua/TypeScript | Inspect Pos |
| `<Space>ul` | 全局；Lua/TypeScript | Toggle Line Numbers |
| `<Space>un` | 全局；Lua/TypeScript | Dismiss All Notifications |
| `<Space>up` | 全局；Lua/TypeScript | Toggle Mini Pairs |
| `<Space>ur` | 全局；Lua/TypeScript | Redraw / Clear hlsearch / Diff Update |
| `<Space>us` | 全局；Lua/TypeScript | Toggle Spelling |
| `<Space>uw` | 全局；Lua/TypeScript | Toggle Wrap |
| `<Space>uz` | 全局；Lua/TypeScript | Toggle Zen Mode |
| `<Space>wd` | 全局；Lua/TypeScript | Delete Window |
| `<Space>wm` | 全局；Lua/TypeScript | Toggle Zoom Mode |
| `<Space>xL` | 全局；Lua/TypeScript | Location List (Trouble) |
| `<Space>xQ` | 全局；Lua/TypeScript | Quickfix List (Trouble) |
| `<Space>xT` | 全局；Lua/TypeScript | Todo/Fix/Fixme (Trouble) |
| `<Space>xX` | 全局；Lua/TypeScript | Buffer Diagnostics (Trouble) |
| `<Space>xl` | 全局；Lua/TypeScript | Location List |
| `<Space>xq` | 全局；Lua/TypeScript | Quickfix List |
| `<Space>xt` | 全局；Lua/TypeScript | Todo (Trouble) |
| `<Space>xx` | 全局；Lua/TypeScript | Diagnostics (Trouble) |
| `<Space>z` | 全局；Lua/TypeScript | Zen Mode |
| `<Space>\|` | 全局；Lua/TypeScript | Split Window Right |
| `%` | 全局；Lua/TypeScript | <Plug>(MatchitNormalForward) |
| `&` | 全局；Lua/TypeScript | :help &-default |
| `+` | 全局；Lua/TypeScript | <C-A> |
| `,` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `-` | 全局；Lua/TypeScript | <C-X> |
| `;` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `;;` | 全局；Lua/TypeScript | Resume the previous telescope picker |
| `;e` | 全局；Lua/TypeScript | Lists Diagnostics for all open buffers or a specific buffer |
| `;f` | 全局；Lua/TypeScript | Lists files in your current working directory, respects .gitignore |
| `;jl` | 全局；Lua/TypeScript | Flash |
| `;r` | 全局；Lua/TypeScript | Search for a string in your current working directory and get results live as you type, respects .gitignore |
| `;s` | 全局；Lua/TypeScript | Lists Function names, variables, from Treesitter |
| `;t` | 全局；Lua/TypeScript | Lists available help tags and opens a new window with the relevant help info on <cr> |
| `<C-/>` | 全局；Lua/TypeScript | Terminal (Root Dir) |
| `<C-A>` | 全局；Lua/TypeScript | ggVG |
| `<C-B>` | 全局；Lua/TypeScript | Scroll Backward |
| `<C-Down>` | 全局；Lua/TypeScript | Decrease Window Height |
| `<C-F>` | 全局；Lua/TypeScript | Scroll Forward |
| `<C-H>` | 全局；Lua/TypeScript | Go to Left Window |
| `<C-J>` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<C-K>` | 全局；Lua/TypeScript | Go to Upper Window |
| `<C-L>` | 全局；Lua/TypeScript | Go to Right Window |
| `<C-Left>` | 全局；Lua/TypeScript | Decrease Window Width |
| `<C-M>` | 全局；Lua/TypeScript | <Tab> |
| `<C-R>` | 全局；Lua/TypeScript | <C-R><Cmd>lua MiniBracketed.register_undo_state()<CR> |
| `<C-Right>` | 全局；Lua/TypeScript | Increase Window Width |
| `<C-S>` | 全局；Lua/TypeScript | Save File |
| `<C-Space>` | 全局；Lua/TypeScript | Treesitter Incremental Selection |
| `<C-Up>` | 全局；Lua/TypeScript | Increase Window Height |
| `<C-W><Space>` | 全局；Lua/TypeScript | Window Hydra Mode (which-key) |
| `<C-W><C-D>` | 全局；Lua/TypeScript | Show diagnostics under the cursor |
| `<C-W><Down>` | 全局；Lua/TypeScript | <C-W>- |
| `<C-W><Left>` | 全局；Lua/TypeScript | <C-W><lt> |
| `<C-W><Right>` | 全局；Lua/TypeScript | <C-W>> |
| `<C-W><Up>` | 全局；Lua/TypeScript | <C-W>+ |
| `<C-W>d` | 全局；Lua/TypeScript | Show diagnostics under the cursor |
| `<C-X>` | 全局；Lua/TypeScript | decrement |
| `<C-_>` | 全局；Lua/TypeScript | which_key_ignore |
| `<Down>` | 全局；Lua/TypeScript | Down |
| `<Esc>` | 全局；Lua/TypeScript | Escape and Clear hlsearch |
| `<M-j>` | 全局；Lua/TypeScript | Move Down |
| `<M-k>` | 全局；Lua/TypeScript | Move Up |
| `<M-n>` | buffer；Lua/TypeScript | Next Reference |
| `<M-p>` | buffer；Lua/TypeScript | Prev Reference |
| `<S-Tab>` | 全局；Lua/TypeScript | :tabprev<CR> |
| `<Tab>` | 全局；Lua/TypeScript | :tabnext<CR> |
| `<Up>` | 全局；Lua/TypeScript | Up |
| `F` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `H` | 全局；Lua/TypeScript | ^ |
| `K` | buffer；Lua/TypeScript | Hover |
| `L` | 全局；Lua/TypeScript | $ |
| `N` | 全局；Lua/TypeScript | Prev Search Result |
| `S` | 全局；Lua/TypeScript | Flash Treesitter |
| `T` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `Y` | 全局；Lua/TypeScript | :help Y-default |
| `[<Space>` | 全局；Lua/TypeScript | Add empty line above cursor |
| `[%` | 全局；Lua/TypeScript | <Plug>(MatchitNormalMultiBackward) |
| `[<C-L>` | 全局；Lua/TypeScript | :lpfile |
| `[<C-Q>` | 全局；Lua/TypeScript | :cpfile |
| `[<C-T>` | 全局；Lua/TypeScript | :ptprevious |
| `[A` | buffer；Lua/TypeScript | Prev Parameter End |
| `[A` | 全局；Lua/TypeScript | :rewind |
| `[B` | 全局；Lua/TypeScript | Move buffer prev |
| `[C` | buffer；Lua/TypeScript | Prev Class End |
| `[C` | 全局；Lua/TypeScript | Comment first |
| `[D` | 全局；Lua/TypeScript | Diagnostic first |
| `[F` | buffer；Lua/TypeScript | Prev Function End |
| `[H` | buffer；Lua | First Hunk |
| `[I` | 全局；Lua/TypeScript | Indent first |
| `[J` | 全局；Lua/TypeScript | Jump first |
| `[L` | 全局；Lua/TypeScript | Location first |
| `[N` | 全局；Lua/TypeScript | Treesitter first |
| `[O` | 全局；Lua/TypeScript | Oldfile first |
| `[Q` | 全局；Lua/TypeScript | :crewind |
| `[T` | 全局；Lua/TypeScript | :trewind |
| `[U` | 全局；Lua/TypeScript | Undo first |
| `[X` | 全局；Lua/TypeScript | Conflict first |
| `[[` | buffer；Lua/TypeScript | Prev Reference |
| `[a` | buffer；Lua/TypeScript | Prev Parameter Start |
| `[a` | 全局；Lua/TypeScript | :previous |
| `[b` | 全局；Lua/TypeScript | Prev Buffer |
| `[c` | buffer；Lua/TypeScript | Prev Class Start |
| `[c` | 全局；Lua/TypeScript | Comment backward |
| `[d` | 全局；Lua/TypeScript | Prev Diagnostic |
| `[e` | 全局；Lua/TypeScript | Prev Error |
| `[f` | buffer；Lua/TypeScript | Prev Function Start |
| `[h` | buffer；Lua | Prev Hunk |
| `[i` | 全局；Lua/TypeScript | jump to top edge of scope |
| `[j` | 全局；Lua/TypeScript | Jump backward |
| `[l` | 全局；Lua/TypeScript | Location backward |
| `[n` | 全局；Lua/TypeScript | Treesitter backward |
| `[o` | 全局；Lua/TypeScript | Oldfile backward |
| `[q` | 全局；Lua/TypeScript | Previous Trouble/Quickfix Item |
| `[t` | 全局；Lua/TypeScript | Previous Todo Comment |
| `[u` | 全局；Lua/TypeScript | Undo backward |
| `[w` | 全局；Lua/TypeScript | Prev Warning |
| `[x` | 全局；Lua/TypeScript | Conflict backward |
| `\\` | 全局；Lua/TypeScript | Lists open buffers |
| `\r` | buffer；Lua | Run Lua |
| `]<Space>` | 全局；Lua/TypeScript | Add empty line below cursor |
| `]%` | 全局；Lua/TypeScript | <Plug>(MatchitNormalMultiForward) |
| `]<C-L>` | 全局；Lua/TypeScript | :lnfile |
| `]<C-Q>` | 全局；Lua/TypeScript | :cnfile |
| `]<C-T>` | 全局；Lua/TypeScript | :ptnext |
| `]A` | buffer；Lua/TypeScript | Next Parameter End |
| `]A` | 全局；Lua/TypeScript | :last |
| `]B` | 全局；Lua/TypeScript | Move buffer next |
| `]C` | buffer；Lua/TypeScript | Next Class End |
| `]C` | 全局；Lua/TypeScript | Comment last |
| `]D` | 全局；Lua/TypeScript | Diagnostic last |
| `]F` | buffer；Lua/TypeScript | Next Function End |
| `]H` | buffer；Lua | Last Hunk |
| `]I` | 全局；Lua/TypeScript | Indent last |
| `]J` | 全局；Lua/TypeScript | Jump last |
| `]L` | 全局；Lua/TypeScript | Location last |
| `]N` | 全局；Lua/TypeScript | Treesitter last |
| `]O` | 全局；Lua/TypeScript | Oldfile last |
| `]Q` | 全局；Lua/TypeScript | :clast |
| `]T` | 全局；Lua/TypeScript | :tlast |
| `]U` | 全局；Lua/TypeScript | Undo last |
| `]X` | 全局；Lua/TypeScript | Conflict last |
| `]]` | buffer；Lua/TypeScript | Next Reference |
| `]a` | buffer；Lua/TypeScript | Next Parameter Start |
| `]a` | 全局；Lua/TypeScript | :next |
| `]b` | 全局；Lua/TypeScript | Next Buffer |
| `]c` | buffer；Lua/TypeScript | Next Class Start |
| `]c` | 全局；Lua/TypeScript | Comment forward |
| `]d` | 全局；Lua/TypeScript | Next Diagnostic |
| `]e` | 全局；Lua/TypeScript | Next Error |
| `]f` | buffer；Lua/TypeScript | Next Function Start |
| `]h` | buffer；Lua | Next Hunk |
| `]i` | 全局；Lua/TypeScript | jump to bottom edge of scope |
| `]j` | 全局；Lua/TypeScript | Jump forward |
| `]l` | 全局；Lua/TypeScript | Location forward |
| `]n` | 全局；Lua/TypeScript | Treesitter forward |
| `]o` | 全局；Lua/TypeScript | Oldfile forward |
| `]q` | 全局；Lua/TypeScript | Next Trouble/Quickfix Item |
| `]t` | 全局；Lua/TypeScript | Next Todo Comment |
| `]u` | 全局；Lua/TypeScript | Undo forward |
| `]w` | 全局；Lua/TypeScript | Next Warning |
| `]x` | 全局；Lua/TypeScript | Conflict forward |
| `dw` | 全局；Lua/TypeScript | vb"_d |
| `f` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `g%` | 全局；Lua/TypeScript | <Plug>(MatchitNormalBackward) |
| `gD` | buffer；Lua | Goto Declaration |
| `gD` | buffer；TypeScript | Goto Source Definition |
| `gI` | buffer；Lua/TypeScript | Goto Implementation |
| `gK` | buffer；Lua/TypeScript | Signature Help |
| `gO` | 全局；Lua/TypeScript | vim.lsp.buf.document_symbol() |
| `gR` | buffer；TypeScript | File References |
| `g[` | 全局；Lua/TypeScript | Move to left "around" |
| `g]` | 全局；Lua/TypeScript | Move to right "around" |
| `gb` | 全局；Lua/TypeScript | Comment toggle blockwise |
| `gbc` | 全局；Lua/TypeScript | Comment toggle current block |
| `gc` | 全局；Lua/TypeScript | Comment toggle linewise |
| `gcA` | 全局；Lua/TypeScript | Comment insert end of line |
| `gcO` | 全局；Lua/TypeScript | Add Comment Above |
| `gcc` | 全局；Lua/TypeScript | Comment toggle current line |
| `gco` | 全局；Lua/TypeScript | Add Comment Below |
| `gd` | buffer；Lua/TypeScript | Goto Definition |
| `gr` | buffer；Lua/TypeScript | References |
| `gra` | 全局；Lua/TypeScript | vim.lsp.buf.code_action() |
| `gri` | 全局；Lua/TypeScript | vim.lsp.buf.implementation() |
| `grn` | 全局；Lua/TypeScript | vim.lsp.buf.rename() |
| `grr` | 全局；Lua/TypeScript | vim.lsp.buf.references() |
| `grt` | 全局；Lua/TypeScript | vim.lsp.buf.type_definition() |
| `grx` | 全局；Lua/TypeScript | vim.lsp.codelens.run() |
| `gx` | 全局；Lua/TypeScript | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| `gy` | buffer；Lua/TypeScript | Goto T[y]pe Definition |
| `h` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `j` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `k` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `l` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `n` | 全局；Lua/TypeScript | Next Search Result |
| `s` | 全局；Lua/TypeScript | Flash |
| `sf` | 全局；Lua/TypeScript | Open File Browser with the path of the current buffer |
| `sh` | 全局；Lua/TypeScript | <C-W>h |
| `sj` | 全局；Lua/TypeScript | <C-W>j |
| `sk` | 全局；Lua/TypeScript | <C-W>k |
| `sl` | 全局；Lua/TypeScript | <C-W>l |
| `ss` | 全局；Lua/TypeScript | :split<CR> |
| `sv` | 全局；Lua/TypeScript | :vsplit<CR> |
| `sw` | 全局；Lua/TypeScript | Flash |
| `t` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `te` | 全局；Lua/TypeScript | :tabedit |
| `u` | 全局；Lua/TypeScript | u<Cmd>lua MiniBracketed.register_undo_state()<CR> |
| `x` | 全局；Lua/TypeScript | "_x |

### 16.2 选择模式 V

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `<Space>C` | 全局；Lua/TypeScript | "_C |
| `<Space>D` | 全局；Lua/TypeScript | "_D |
| `<Space>aa` | 全局；Lua/TypeScript | avante: ask |
| `<Space>ae` | 全局；Lua/TypeScript | avante: edit |
| `<Space>an` | 全局；Lua/TypeScript | avante: create new ask |
| `<Space>az` | 全局；Lua/TypeScript | avante: toggle Zen Mode |
| `<Space>c` | 全局；Lua/TypeScript | "_c |
| `<Space>cF` | 全局；Lua/TypeScript | Format Injected Langs |
| `<Space>ca` | buffer；Lua/TypeScript | Code Action |
| `<Space>cc` | buffer；Lua/TypeScript | Run Codelens |
| `<Space>cf` | 全局；Lua/TypeScript | Format |
| `<Space>d` | 全局；Lua/TypeScript | "_d |
| `<Space>gB` | 全局；Lua/TypeScript | Git Browse (open) |
| `<Space>gY` | 全局；Lua/TypeScript | Git Browse (copy) |
| `<Space>ghr` | buffer；Lua | Reset Hunk |
| `<Space>ghs` | buffer；Lua | Stage Hunk |
| `<Space>go` | 全局；Lua/TypeScript | :<C-U> lua require('git.browse').open(true)<CR> |
| `<Space>p` | 全局；Lua/TypeScript | "0p |
| `<Space>r` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<Space>sW` | 全局；Lua/TypeScript | Selection (cwd) |
| `<Space>sr` | 全局；Lua/TypeScript | Search and Replace |
| `<Space>sw` | 全局；Lua/TypeScript | Selection (Root Dir) |
| `#` | 全局；Lua/TypeScript | :help v_#-default |
| `%` | 全局；Lua/TypeScript | <Plug>(MatchitVisualForward) |
| `*` | 全局；Lua/TypeScript | :help v_star-default |
| `,` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `;` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `;jl` | 全局；Lua/TypeScript | Flash |
| `<C-S>` | 全局；Lua/TypeScript | Save File |
| `<C-Space>` | 全局；Lua/TypeScript | Treesitter Incremental Selection |
| `<Down>` | 全局；Lua/TypeScript | Down |
| `<M-j>` | 全局；Lua/TypeScript | Move Down |
| `<M-k>` | 全局；Lua/TypeScript | Move Up |
| `<Up>` | 全局；Lua/TypeScript | Up |
| `<lt>` | 全局；Lua/TypeScript | <lt>gv |
| `>` | 全局；Lua/TypeScript | >gv |
| `@` | 全局；Lua/TypeScript | :help v_@-default |
| `F` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `L` | 全局；Lua/TypeScript | $ |
| `N` | 全局；Lua/TypeScript | Prev Search Result |
| `Q` | 全局；Lua/TypeScript | :help v_Q-default |
| `R` | 全局；Lua/TypeScript | Treesitter Search |
| `S` | 全局；Lua/TypeScript | Flash Treesitter |
| `T` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `[%` | 全局；Lua/TypeScript | <Plug>(MatchitVisualMultiBackward) |
| `[A` | buffer；Lua/TypeScript | Prev Parameter End |
| `[C` | buffer；Lua/TypeScript | Prev Class End |
| `[C` | 全局；Lua/TypeScript | Comment first |
| `[D` | 全局；Lua/TypeScript | Diagnostic first |
| `[F` | buffer；Lua/TypeScript | Prev Function End |
| `[I` | 全局；Lua/TypeScript | Indent first |
| `[N` | 全局；Lua/TypeScript | Treesitter first |
| `[X` | 全局；Lua/TypeScript | Conflict first |
| `[a` | buffer；Lua/TypeScript | Prev Parameter Start |
| `[c` | buffer；Lua/TypeScript | Prev Class Start |
| `[c` | 全局；Lua/TypeScript | Comment backward |
| `[d` | 全局；Lua/TypeScript | Diagnostic backward |
| `[f` | buffer；Lua/TypeScript | Prev Function Start |
| `[i` | 全局；Lua/TypeScript | jump to top edge of scope |
| `[n` | 全局；Lua/TypeScript | Treesitter backward |
| `[x` | 全局；Lua/TypeScript | Conflict backward |
| `\r` | buffer；Lua | Run Lua |
| `]%` | 全局；Lua/TypeScript | <Plug>(MatchitVisualMultiForward) |
| `]A` | buffer；Lua/TypeScript | Next Parameter End |
| `]C` | buffer；Lua/TypeScript | Next Class End |
| `]C` | 全局；Lua/TypeScript | Comment last |
| `]D` | 全局；Lua/TypeScript | Diagnostic last |
| `]F` | buffer；Lua/TypeScript | Next Function End |
| `]I` | 全局；Lua/TypeScript | Indent last |
| `]N` | 全局；Lua/TypeScript | Treesitter last |
| `]X` | 全局；Lua/TypeScript | Conflict last |
| `]a` | buffer；Lua/TypeScript | Next Parameter Start |
| `]c` | buffer；Lua/TypeScript | Next Class Start |
| `]c` | 全局；Lua/TypeScript | Comment forward |
| `]d` | 全局；Lua/TypeScript | Diagnostic forward |
| `]f` | buffer；Lua/TypeScript | Next Function Start |
| `]i` | 全局；Lua/TypeScript | jump to bottom edge of scope |
| `]n` | 全局；Lua/TypeScript | Treesitter forward |
| `]x` | 全局；Lua/TypeScript | Conflict forward |
| `a` | 全局；Lua/TypeScript | Around textobject |
| `a%` | 全局；Lua/TypeScript | <Plug>(MatchitVisualTextObject) |
| `ai` | 全局；Lua/TypeScript | full scope |
| `al` | 全局；Lua/TypeScript | Around last textobject |
| `an` | 全局；Lua/TypeScript | Around next textobject |
| `f` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `g%` | 全局；Lua/TypeScript | <Plug>(MatchitVisualBackward) |
| `g[` | 全局；Lua/TypeScript | Move to left "around" |
| `g]` | 全局；Lua/TypeScript | Move to right "around" |
| `gb` | 全局；Lua/TypeScript | Comment toggle blockwise (visual) |
| `gc` | 全局；Lua/TypeScript | Comment toggle linewise (visual) |
| `gra` | 全局；Lua/TypeScript | vim.lsp.buf.code_action() |
| `gx` | 全局；Lua/TypeScript | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| `i` | 全局；Lua/TypeScript | Inside textobject |
| `ih` | buffer；Lua | GitSigns Select Hunk |
| `ii` | 全局；Lua/TypeScript | inner scope |
| `il` | 全局；Lua/TypeScript | Inside last textobject |
| `in` | 全局；Lua/TypeScript | Inside next textobject |
| `j` | 全局；Lua/TypeScript | Down |
| `k` | 全局；Lua/TypeScript | Up |
| `n` | 全局；Lua/TypeScript | Next Search Result |
| `s` | 全局；Lua/TypeScript | Flash |
| `sw` | 全局；Lua/TypeScript | Flash |
| `t` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |

### 16.3 插入模式 I

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `"` | buffer；TypeScript | autopairs map key |
| `"` | 全局；Lua/TypeScript | Closeopen action for '""' pair |
| `'` | buffer；TypeScript | autopairs map key |
| `'` | 全局；Lua/TypeScript | Closeopen action for "''" pair |
| `(` | buffer；TypeScript | autopairs map key |
| `(` | 全局；Lua/TypeScript | Open action for "()" pair |
| `)` | buffer；TypeScript | autopairs map key |
| `)` | 全局；Lua/TypeScript | Close action for "()" pair |
| `,` | 全局；Lua/TypeScript | ,<C-G>u |
| `.` | 全局；Lua/TypeScript | .<C-G>u |
| `;` | 全局；Lua/TypeScript | ;<C-G>u |
| `<BS>` | buffer；TypeScript | autopairs delete |
| `<BS>` | 全局；Lua | MiniPairs <BS> |
| `<C-B>` | 全局；Lua/TypeScript | Scroll Backward |
| `<C-CR>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<C-E>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<C-F>` | 全局；Lua/TypeScript | Scroll Forward |
| `<C-K>` | buffer；Lua/TypeScript | Signature Help |
| `<C-N>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<C-P>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<C-S>` | 全局；Lua/TypeScript | Save File |
| `<C-Space>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<C-U>` | 全局；Lua/TypeScript | :help i_CTRL-U-default |
| `<C-W>` | 全局；Lua/TypeScript | :help i_CTRL-W-default |
| `<C-Y>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<CR>` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<Down>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<Esc>` | 全局；Lua/TypeScript | Escape and Clear hlsearch |
| `<M-j>` | 全局；Lua/TypeScript | Move Down |
| `<M-k>` | 全局；Lua/TypeScript | Move Up |
| `<S-CR>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<S-Tab>` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<Tab>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `<Tab>` | 全局；Lua | vim.snippet.jump if active, otherwise <Tab> |
| `<Up>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `>` | buffer；TypeScript | Lua 回调（参见正文/配置） |
| `[` | buffer；TypeScript | autopairs map key |
| `[` | 全局；Lua/TypeScript | Open action for "[]" pair |
| `]` | buffer；TypeScript | autopairs map key |
| `]` | 全局；Lua/TypeScript | Close action for "[]" pair |
| `&#96;` | buffer；TypeScript | autopairs map key |
| `&#96;` | 全局；Lua/TypeScript | Closeopen action for "&#96;&#96;" pair |
| `jk` | 全局；Lua/TypeScript | <Esc> |
| `{` | buffer；TypeScript | autopairs map key |
| `{` | 全局；Lua/TypeScript | Open action for "{}" pair |
| `}` | buffer；TypeScript | autopairs map key |
| `}` | 全局；Lua/TypeScript | Close action for "{}" pair |

### 16.4 片段 Select 模式

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `<Space>C` | 全局；Lua/TypeScript | "_C |
| `<Space>D` | 全局；Lua/TypeScript | "_D |
| `<Space>aa` | 全局；Lua/TypeScript | avante: ask |
| `<Space>ae` | 全局；Lua/TypeScript | avante: edit |
| `<Space>an` | 全局；Lua/TypeScript | avante: create new ask |
| `<Space>az` | 全局；Lua/TypeScript | avante: toggle Zen Mode |
| `<Space>c` | 全局；Lua/TypeScript | "_c |
| `<Space>d` | 全局；Lua/TypeScript | "_d |
| `<Space>p` | 全局；Lua/TypeScript | "0p |
| `<Space>r` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<C-B>` | 全局；Lua/TypeScript | Scroll Backward |
| `<C-F>` | 全局；Lua/TypeScript | Scroll Forward |
| `<C-S>` | 全局；Lua/TypeScript | Save File |
| `<Esc>` | 全局；Lua/TypeScript | Escape and Clear hlsearch |
| `<M-j>` | 全局；Lua/TypeScript | Move Down |
| `<M-k>` | 全局；Lua/TypeScript | Move Up |
| `<S-Tab>` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `<Tab>` | 全局；Lua | Lua 回调（参见正文/配置） |
| `<Tab>` | 全局；TypeScript | cmp.utils.keymap.set_map |
| `L` | 全局；Lua/TypeScript | $ |

### 16.5 操作符等待模式

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `%` | 全局；Lua/TypeScript | <Plug>(MatchitOperationForward) |
| `,` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `;` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `;jl` | 全局；Lua/TypeScript | Flash |
| `<C-Space>` | 全局；Lua/TypeScript | Treesitter Incremental Selection |
| `F` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `N` | 全局；Lua/TypeScript | Prev Search Result |
| `R` | 全局；Lua/TypeScript | Treesitter Search |
| `S` | 全局；Lua/TypeScript | Flash Treesitter |
| `T` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `[%` | 全局；Lua/TypeScript | <Plug>(MatchitOperationMultiBackward) |
| `[A` | buffer；Lua/TypeScript | Prev Parameter End |
| `[C` | buffer；Lua/TypeScript | Prev Class End |
| `[C` | 全局；Lua/TypeScript | Comment first |
| `[D` | 全局；Lua/TypeScript | Diagnostic first |
| `[F` | buffer；Lua/TypeScript | Prev Function End |
| `[I` | 全局；Lua/TypeScript | Indent first |
| `[J` | 全局；Lua/TypeScript | Jump first |
| `[N` | 全局；Lua/TypeScript | Treesitter first |
| `[X` | 全局；Lua/TypeScript | Conflict first |
| `[a` | buffer；Lua/TypeScript | Prev Parameter Start |
| `[c` | buffer；Lua/TypeScript | Prev Class Start |
| `[c` | 全局；Lua/TypeScript | Comment backward |
| `[d` | 全局；Lua/TypeScript | Diagnostic backward |
| `[f` | buffer；Lua/TypeScript | Prev Function Start |
| `[i` | 全局；Lua/TypeScript | jump to top edge of scope |
| `[j` | 全局；Lua/TypeScript | Jump backward |
| `[n` | 全局；Lua/TypeScript | Treesitter backward |
| `[x` | 全局；Lua/TypeScript | Conflict backward |
| `]%` | 全局；Lua/TypeScript | <Plug>(MatchitOperationMultiForward) |
| `]A` | buffer；Lua/TypeScript | Next Parameter End |
| `]C` | buffer；Lua/TypeScript | Next Class End |
| `]C` | 全局；Lua/TypeScript | Comment last |
| `]D` | 全局；Lua/TypeScript | Diagnostic last |
| `]F` | buffer；Lua/TypeScript | Next Function End |
| `]I` | 全局；Lua/TypeScript | Indent last |
| `]J` | 全局；Lua/TypeScript | Jump last |
| `]N` | 全局；Lua/TypeScript | Treesitter last |
| `]X` | 全局；Lua/TypeScript | Conflict last |
| `]a` | buffer；Lua/TypeScript | Next Parameter Start |
| `]c` | buffer；Lua/TypeScript | Next Class Start |
| `]c` | 全局；Lua/TypeScript | Comment forward |
| `]d` | 全局；Lua/TypeScript | Diagnostic forward |
| `]f` | buffer；Lua/TypeScript | Next Function Start |
| `]i` | 全局；Lua/TypeScript | jump to bottom edge of scope |
| `]j` | 全局；Lua/TypeScript | Jump forward |
| `]n` | 全局；Lua/TypeScript | Treesitter forward |
| `]x` | 全局；Lua/TypeScript | Conflict forward |
| `a` | 全局；Lua/TypeScript | Around textobject |
| `ai` | 全局；Lua/TypeScript | full scope |
| `al` | 全局；Lua/TypeScript | Around last textobject |
| `an` | 全局；Lua/TypeScript | Around next textobject |
| `f` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |
| `g%` | 全局；Lua/TypeScript | <Plug>(MatchitOperationBackward) |
| `g[` | 全局；Lua/TypeScript | Move to left "around" |
| `g]` | 全局；Lua/TypeScript | Move to right "around" |
| `gc` | 全局；Lua/TypeScript | Comment textobject |
| `i` | 全局；Lua/TypeScript | Inside textobject |
| `ih` | buffer；Lua | GitSigns Select Hunk |
| `ii` | 全局；Lua/TypeScript | inner scope |
| `il` | 全局；Lua/TypeScript | Inside last textobject |
| `in` | 全局；Lua/TypeScript | Inside next textobject |
| `n` | 全局；Lua/TypeScript | Next Search Result |
| `r` | 全局；Lua/TypeScript | Remote Flash |
| `s` | 全局；Lua/TypeScript | Flash |
| `sw` | 全局；Lua/TypeScript | Flash |
| `t` | 全局；Lua/TypeScript | Lua 回调（参见正文/配置） |

### 16.6 终端模式 T

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `<C-/>` | 全局；Lua/TypeScript | Terminal (Root Dir) |
| `<C-_>` | 全局；Lua/TypeScript | which_key_ignore |

### 16.7 命令行模式

| 按键 | 范围 / 观察场景 | 描述或映射目标 |
|---|---|---|
| `"` | 全局；Lua/TypeScript | Closeopen action for '""' pair |
| `'` | 全局；Lua/TypeScript | Closeopen action for "''" pair |
| `(` | 全局；Lua/TypeScript | Open action for "()" pair |
| `)` | 全局；Lua/TypeScript | Close action for "()" pair |
| `<BS>` | 全局；Lua/TypeScript | MiniPairs <BS> |
| `<C-S>` | 全局；Lua/TypeScript | Toggle Flash Search |
| `<S-CR>` | 全局；Lua/TypeScript | Redirect Cmdline |
| `[` | 全局；Lua/TypeScript | Open action for "[]" pair |
| `]` | 全局；Lua/TypeScript | Close action for "[]" pair |
| `&#96;` | 全局；Lua/TypeScript | Closeopen action for "&#96;&#96;" pair |
| `{` | 全局；Lua/TypeScript | Open action for "{}" pair |
| `}` | 全局；Lua/TypeScript | Close action for "{}" pair |

## 17. 每天先记住这组

`Space Space` 找文件 → `Space /` 搜项目 → `gd/gr/K` 读代码 → `Ctrl-y` 接受补全 → `Space c a/c r` 修正和重命名 → `Ctrl-s` 保存 → `Space x x` 看问题 → `Space f t` 跑服务与检查 → `Space g e` 审查、暂存、提交 → `Space q q` 退出。
