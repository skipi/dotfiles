return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = { exclude = { "stylua" } },
      ensure_installed = {
        "lua_ls",
        "gopls",
        "ts_ls",
        "ruby_lsp",
        "elixirls",
        "yamlls",
        "jsonls",
        "bashls",
      },
    },
    init = function()
      vim.diagnostic.config({
        severity_sort = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
        float = { border = "rounded", source = "if_many", header = "", prefix = "" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            staticcheck = true,
            analyses = { unusedparams = true, shadow = true, nilness = true },
            hints = { parameterNames = true, assignVariableTypes = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = { keyOrdering = false, validate = true },
        },
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        ghost_text = { enabled = false },
        menu = { border = "rounded" },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports" },
        elixir = { "mix_format" },
        ruby = { "rubocop" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
  },
}
