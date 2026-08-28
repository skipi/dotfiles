return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      styles = { comments = { italic = true }, keywords = { italic = false } },
      on_highlights = function(hl, c)
        hl.LineNrAbove = { fg = c.dark3 }
        hl.LineNrBelow = { fg = c.dark3 }
        hl.CursorLineNr = { fg = c.orange, bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = false,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
      preview_config = { border = "rounded" },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        section_separators = "",
        component_separators = "│",
        disabled_filetypes = { statusline = { "oil" } },
      },
      sections = {
        lualine_a = { { "mode", fmt = function(s) return s:sub(1, 1) end } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
          {
            function()
              local names = {}
              for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                names[#names + 1] = c.name
              end
              return table.concat(names, " ")
            end,
            icon = " ",
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 400,
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "buffer" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>u", group = "toggle" },
        { "<leader>s", group = "search" },
      },
    },
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    init = function() vim.g.tmux_navigator_no_mappings = 1 end,
  },

  { "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },
}
