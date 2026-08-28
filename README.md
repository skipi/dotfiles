# dotfiles

Neovim + tmux config. Symlinked into `~/.config`.

## Layout

```
nvim/
  init.lua                 leader, then three requires
  lua/config/options.lua   editor behaviour + two autocmds
  lua/config/lazy.lua      plugin manager bootstrap
  lua/config/keymaps.lua   every mapping, including LSP (via LspAttach)
  lua/plugins/editor.lua   telescope, treesitter, oil, flash, trouble
  lua/plugins/lsp.lua      mason + lspconfig + blink.cmp + conform
  lua/plugins/ui.lua       tokyonight, lualine, gitsigns, which-key
tmux/tmux.conf             prefix C-a, vi copy mode, tokyonight status
bin/tmux-sessionizer       fzf jump to any repo/worktree/project as a session
```

Every keybinding lives in `lua/config/keymaps.lua`. Nothing is hidden in a plugin spec.

[CHEATSHEET.md](CHEATSHEET.md) is the full keybinding reference, plus notes on adding plugins.

## Install on a new machine

```sh
brew install neovim tmux ripgrep fd fzf lazygit bat tree-sitter-cli
git clone <this-repo> ~/dotfiles
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/tmux ~/.config/tmux
nvim   # lazy.nvim bootstraps itself, then :MasonInstall runs from ensure_installed
```

Add `~/dotfiles/bin` to `PATH` to call `tmux-sessionizer` outside tmux.

## Language servers

Managed by Mason, declared in `lua/plugins/lsp.lua` under `ensure_installed`: `lua_ls`, `gopls`, `ts_ls`, `ruby_lsp`, `elixirls`, `yamlls`, `jsonls`, `bashls`.

`ruby_lsp` runs `bundle install` in the project on first attach. In a repo whose gems are not installed locally it will sit there failing until you run `bundle install` yourself — that is the repo's state, not a config problem.

`stylua` is explicitly excluded from `automatic_enable`: Mason maps it to an LSP server (`stylua --lsp`) that duplicates what conform already does.

## Formatting

`conform.nvim`, bound to `<leader>cf`. Format-on-save is deliberately **off** — these repos have their own CI formatting gates and a stray reformat makes noisy diffs. Turn it on by adding `format_on_save = { timeout_ms = 500, lsp_format = "fallback" }` to the conform `opts`.

## Updating

- `:Lazy` — plugin manager UI. `U` updates, `S` syncs, `x` cleans removed plugins.
- `:Mason` — LSP server UI. `U` updates a package.
- `:TSUpdate` — treesitter parsers. Required after a nvim-treesitter update; the pinned parser versions move with the plugin.
- `:checkhealth` — first stop when something breaks.
