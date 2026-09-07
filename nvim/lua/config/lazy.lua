local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Define enabled plugins for VSCode
local enabled = {
  "LazyVim",
  "dial.nvim",
  "flit.nvim",
  "lazy.nvim",
  "leap.nvim",
  "mini.ai",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "snacks.nvim",
  "ts-comments.nvim",
  "vim-repeat",
  "yanky.nvim",
}

if vim.g.vscode then
  vim.g.snacks_animate = false

  -- VSCode Neovim configuration
  local config = {
    spec = {
      -- VSCode specific plugins
      { import = "lazyvim.plugins.extras.vscode" },
      {
        "snacks.nvim",
        opts = {
          bigfile = { enabled = false },
          dashboard = { enabled = false },
          indent = { enabled = false },
          input = { enabled = false },
          notifier = { enabled = false },
          picker = { enabled = false },
          quickfile = { enabled = false },
          scroll = { enabled = false },
          statuscolumn = { enabled = false },
        },
      },
      {
        "LazyVim/LazyVim",
        config = function(_, opts)
          opts = opts or {}
          -- disable the colorscheme
          opts.colorscheme = function() end
          require("lazyvim").setup(opts)
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter",
        opts = { highlight = { enable = false } },
      },
    },
    defaults = {
      -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
      cond = function(plugin)
        return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
      end,
    },
    checker = { enabled = false },
    change_detection = { enabled = false },
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }

  -- Setup lazy.nvim with VSCode configuration
  require("lazy").setup(config)

  -- Add VSCode specific keymaps
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimKeymapsDefaults",
    callback = function()
      -- VSCode-specific keymaps for search and navigation
      vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
      vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
      vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])
      -- Keep undo/redo lists in sync with VsCode
      vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
      vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")
      -- Navigate VSCode tabs like lazyvim buffers
      vim.keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
      vim.keymap.set("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
    end,
  })

  -- Terminal function for VSCode
  _G.LazyVim = _G.LazyVim or {}
  LazyVim.terminal = function()
    require("vscode").action("workbench.action.terminal.toggleTerminal")
  end
else
  -- Regular Neovim configuration
  require("lazy").setup({
    spec = {
      -- add LazyVim and import its plugins
      {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins",
        opts = {
          colorscheme = "github_dark",
          news = {
            lazyvim = true,
            neovim = true,
          },
        },
      },
      -- Preserve the existing completion and snippet configuration.
      { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
      { import = "lazyvim.plugins.extras.coding.luasnip" },
      -- import any extras modules here
      { import = "lazyvim.plugins.extras.linting.eslint" },
      { import = "lazyvim.plugins.extras.formatting.prettier" },
      { import = "lazyvim.plugins.extras.lang.typescript" },
      { import = "lazyvim.plugins.extras.lang.json" },
      -- { import = "lazyvim.plugins.extras.lang.markdown" },
      { import = "lazyvim.plugins.extras.lang.rust" },
      { import = "lazyvim.plugins.extras.lang.tailwind" },
      { import = "lazyvim.plugins.extras.ai.copilot" },
      -- { import = "lazyvim.plugins.extras.dap.core" },
      -- { import = "lazyvim.plugins.extras.vscode" },
      { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
      -- { import = "lazyvim.plugins.extras.test.core" },
      -- { import = "lazyvim.plugins.extras.coding.yanky" },
      -- { import = "lazyvim.plugins.extras.editor.mini-files" },
      -- { import = "lazyvim.plugins.extras.util.project" },
      { import = "plugins" },
    },
    defaults = {
      -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    rocks = { enabled = false }, -- No configured plugins require LuaRocks.
    dev = {
      path = "~/.ghq/github.com",
    },
    checker = { enabled = true }, -- automatically check for plugin updates
    performance = {
      cache = {
        enabled = true,
        -- disable_events = {},
      },
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      custom_keys = {
        ["<localleader>d"] = function(plugin)
          dd(plugin)
        end,
      },
    },
    debug = false,
  })
end
