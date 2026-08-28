local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "n", "nzzzv", { desc = "Next match, centred" })
map("n", "N", "Nzzzv", { desc = "Prev match, centred" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("x", "p", [["_dP]], { desc = "Paste without clobbering register" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Window/pane left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Window/pane down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Window/pane up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Window/pane right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>")
map("n", "<C-Down>", "<cmd>resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -4<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +4<cr>")
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete other buffers" })

map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>e", function() require("oil").toggle_float() end, { desc = "File explorer (float)" })

local function tb(fn, opts)
  return function() require("telescope.builtin")[fn](opts or {}) end
end

map("n", "<leader><leader>", tb("buffers"), { desc = "Switch buffer" })
map("n", "<leader>ff", tb("find_files"), { desc = "Find files" })
map("n", "<leader>fg", tb("live_grep"), { desc = "Live grep" })
map("n", "<leader>fw", tb("grep_string"), { desc = "Grep word under cursor" })
map("v", "<leader>fw", tb("grep_string"), { desc = "Grep selection" })
map("n", "<leader>fb", tb("buffers"), { desc = "Buffers" })
map("n", "<leader>fo", tb("oldfiles"), { desc = "Recent files" })
map("n", "<leader>fh", tb("help_tags"), { desc = "Help tags" })
map("n", "<leader>fk", tb("keymaps"), { desc = "Keymaps" })
map("n", "<leader>fc", tb("commands"), { desc = "Commands" })
map("n", "<leader>fs", tb("lsp_document_symbols"), { desc = "Document symbols" })
map("n", "<leader>fS", tb("lsp_dynamic_workspace_symbols"), { desc = "Workspace symbols" })
map("n", "<leader>fd", tb("diagnostics", { bufnr = 0 }), { desc = "Buffer diagnostics" })
map("n", "<leader>fD", tb("diagnostics"), { desc = "Workspace diagnostics" })
map("n", "<leader>fr", tb("resume"), { desc = "Resume last picker" })
map("n", "<leader>f/", tb("current_buffer_fuzzy_find"), { desc = "Search in buffer" })
map("n", "<leader>gc", tb("git_commits"), { desc = "Git commits" })
map("n", "<leader>gb", tb("git_bcommits"), { desc = "Git commits (buffer)" })
map("n", "<leader>gs", tb("git_status"), { desc = "Git status" })

map("n", "<leader>fn", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find in nvim config" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(ev)
    local o = function(desc) return { buffer = ev.buf, desc = desc } end

    map("n", "gd", tb("lsp_definitions"), o("Go to definition"))
    map("n", "gr", tb("lsp_references"), o("References"))
    map("n", "gi", tb("lsp_implementations"), o("Implementations"))
    map("n", "gy", tb("lsp_type_definitions"), o("Type definition"))
    map("n", "gD", vim.lsp.buf.declaration, o("Go to declaration"))
    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, o("Hover docs"))
    map("n", "<leader>cr", vim.lsp.buf.rename, o("Rename symbol"))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, o("Code action"))
    map("n", "<leader>cf", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, o("Format buffer"))

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight") then
      local g = vim.api.nvim_create_augroup("lsp_highlight_" .. ev.buf, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = ev.buf, group = g, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = ev.buf, group = g, callback = vim.lsp.buf.clear_references,
      })
    end

    if client and client:supports_method("textDocument/inlayHint") then
      map("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, o("Toggle inlay hints"))
    end
  end,
})

map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics list" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics list" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbol outline" })
map("n", "<leader>xr", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/defs" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "TODOs" })

map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev hunk" })
map("n", "<leader>gp", function() require("gitsigns").preview_hunk_inline() end, { desc = "Preview hunk" })
map("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
map("n", "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line (full)" })
map("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "Diff this file" })
map("n", "<leader>ub", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle inline blame" })

map("n", "<leader>gg", function()
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.94),
    height = math.floor(vim.o.lines * 0.92),
    col = math.floor(vim.o.columns * 0.03),
    row = math.floor(vim.o.lines * 0.04),
    style = "minimal",
    border = "rounded",
  })
  vim.fn.jobstart({ "lazygit" }, {
    term = true,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end,
  })
  vim.cmd.startinsert()
end, { desc = "Lazygit" })

map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
map("o", "r", function() require("flash").remote() end, { desc = "Remote flash" })

local function sel(obj)
  return function() require("nvim-treesitter-textobjects.select").select_textobject(obj, "textobjects") end
end
local function move(dir, obj)
  return function() require("nvim-treesitter-textobjects.move")[dir](obj, "textobjects") end
end

map({ "x", "o" }, "af", sel("@function.outer"), { desc = "a function" })
map({ "x", "o" }, "if", sel("@function.inner"), { desc = "inner function" })
map({ "x", "o" }, "ac", sel("@class.outer"), { desc = "a class" })
map({ "x", "o" }, "ic", sel("@class.inner"), { desc = "inner class" })
map({ "x", "o" }, "aa", sel("@parameter.outer"), { desc = "a parameter" })
map({ "x", "o" }, "ia", sel("@parameter.inner"), { desc = "inner parameter" })
map({ "x", "o" }, "a/", sel("@comment.outer"), { desc = "a comment" })

map({ "n", "x", "o" }, "]f", move("goto_next_start", "@function.outer"), { desc = "Next function" })
map({ "n", "x", "o" }, "[f", move("goto_previous_start", "@function.outer"), { desc = "Prev function" })
map({ "n", "x", "o" }, "]c", move("goto_next_start", "@class.outer"), { desc = "Next class" })
map({ "n", "x", "o" }, "[c", move("goto_previous_start", "@class.outer"), { desc = "Prev class" })

map("n", "<leader>uw", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle wrap" })
map("n", "<leader>us", function() vim.opt.spell = not vim.opt.spell:get() end, { desc = "Toggle spell" })
map("n", "<leader>ud", function()
  local on = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not on)
end, { desc = "Toggle diagnostics" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>t", function() vim.cmd("botright 15split | terminal") end, { desc = "Terminal split" })
