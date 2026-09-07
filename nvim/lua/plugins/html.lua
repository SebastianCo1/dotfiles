return {
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        java = false,
        javascript = { "template_string" },
        lua = false,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load HTML snippets
      require("luasnip").add_snippets("html", {
        luasnip.parser.parse_snippet("div", "<div>$1</div>"),
        luasnip.parser.parse_snippet("p", "<p>$1</p>"),
        luasnip.parser.parse_snippet("span", "<span>$1</span>"),
        -- 添加更多HTML标签...
      })

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
      })

    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip").config.set_config({
        region_check_events = "InsertEnter",
        delete_check_events = "InsertLeave",
      })
    end,
  },
}
