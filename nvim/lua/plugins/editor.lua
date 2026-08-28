return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "▍ ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
            horizontal = { preview_width = 0.55 },
            vertical = { preview_height = 0.5 },
            flex = { flip_columns = 150 },
            width = 0.92,
            height = 0.88,
          },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
            "--glob", "!**/.git/*",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-u>"] = false,
              ["<Esc>"] = actions.close,
            },
            n = { ["q"] = actions.close },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" },
          },
          buffers = { sort_mru = true, ignore_current_buffer = true },
          lsp_references = { include_declaration = false, show_line = false },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      require("nvim-treesitter").install({
        "bash", "c", "css", "diff", "dockerfile", "eex", "elixir", "erlang",
        "git_config", "git_rebase", "gitcommit", "gitignore", "go", "gomod",
        "gosum", "gowork", "gotmpl", "heex", "html", "javascript", "jsdoc",
        "json", "lua", "luadoc", "luap", "make", "markdown",
        "markdown_inline", "printf", "python", "query", "regex", "ruby",
        "rust", "scss", "sql", "toml", "tsx", "typescript", "vim", "vimdoc",
        "xml", "yaml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          if not pcall(vim.treesitter.start, ev.buf) then return end
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function() vim.g.no_plugin_maps = true end,
    opts = {
      select = { lookahead = true, selection_modes = { ["@function.outer"] = "V" } },
      move = { set_jumps = true },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      float = { padding = 4, max_width = 120, max_height = 40 },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["q"] = "actions.close",
      },
    },
  },

  { "folke/flash.nvim", event = "VeryLazy", opts = { modes = { char = { enabled = false } } } },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true, warn_no_results = false, open_no_results = true },
  },

  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}
