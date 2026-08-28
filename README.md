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

`rust_analyzer` is deliberately **not** in `ensure_installed`. It comes from rustup (`rustup component add rust-analyzer`), which keeps it version-matched to the toolchain and lets it honour a project's `rust-toolchain.toml`; a Mason-installed copy is a standalone release that drifts from it. It is turned on with an explicit `vim.lsp.enable("rust_analyzer")` because `automatic_enable` only covers servers Mason installed.

Rust diagnostics come from `cargo clippy` via `checkOnSave`, so clippy and rustc warnings appear **on write**, not as you type — rust-analyzer's own type errors are live. Both are tagged by source (`rustc`, `clippy`) in the diagnostic list.

`stylua` is explicitly excluded from `automatic_enable`: Mason maps it to an LSP server (`stylua --lsp`) that duplicates what conform already does.

## Formatting

`conform.nvim`, bound to `<leader>cf`. Format-on-save is deliberately **off** — these repos have their own CI formatting gates and a stray reformat makes noisy diffs. Turn it on by adding `format_on_save = { timeout_ms = 500, lsp_format = "fallback" }` to the conform `opts`.

## Updating

- `:Lazy` — plugin manager UI. `U` updates, `S` syncs, `x` cleans removed plugins.
- `:Mason` — LSP server UI. `U` updates a package.
- `:TSUpdate` — treesitter parsers. Required after a nvim-treesitter update; the pinned parser versions move with the plugin.
- `:checkhealth` — first stop when something breaks.

## Running this config in a container

Bind the config in; never bind `~/.local/share/nvim`. That directory holds compiled treesitter parsers and Mason-installed language servers built for the **host** — Mach-O/arm64 on a Mac, which will not load on Linux. Give the container its own named volume and it builds its own Linux copies on first launch.

| Mount | Why |
|---|---|
| `~/dotfiles/nvim` → `/root/.config/nvim` (`:ro`) | 44K of Lua, portable |
| `~/.local/opt/nvim-linux-<arch>` → `/opt/nvim` (`:ro`) | a Linux nvim, so no image changes |
| named volume → `/root/.local/share/nvim` | plugins + parsers, built for Linux |
| named volume → `/root/.local/state/nvim` | undo history, lockfile fallback |

```sh
docker run --rm -it \
  -v ~/dotfiles/nvim:/root/.config/nvim:ro \
  -v ~/.local/opt/nvim-linux-arm64:/opt/nvim:ro \
  -v nvim-data:/root/.local/share/nvim \
  -v nvim-state:/root/.local/state/nvim \
  -v "$PWD":/work -w /work \
  <your-image> /opt/nvim/bin/nvim
```

Get the Linux nvim once, matching the container's architecture:

```sh
mkdir -p ~/.local/opt && cd ~/.local/opt
curl -fsSL https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-arm64.tar.gz | tar -xz
```

As a compose fragment:

```yaml
services:
  app:
    volumes:
      - ~/dotfiles/nvim:/root/.config/nvim:ro
      - ~/.local/opt/nvim-linux-arm64:/opt/nvim:ro
      - nvim-data:/root/.local/share/nvim
      - nvim-state:/root/.local/state/nvim
volumes:
  nvim-data:
  nvim-state:
```

**Requirements in the image.** glibc **2.33 or newer** — Ubuntu 22.04 works, 20.04 does not (`GLIBC_2.33 not found`). Plus `git`, `curl`, `ca-certificates`, a C compiler, and the `tree-sitter` CLI for building parsers:

```sh
apt-get install -y git curl ca-certificates build-essential
curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-linux-arm64.gz \
  | gunzip > /usr/local/bin/tree-sitter && chmod +x /usr/local/bin/tree-sitter
```

The config mounts read-only safely: when `stdpath("config")` is not writable, `lazy.lua` puts `lazy-lock.json` in the state volume instead, so `:Lazy sync` works in the container without touching the repo copy.

## Nix

Nothing here is Nix-specific — it is plain Lua reading `~/.config/nvim`, so a `nix develop` shell needs no special handling.

The one thing that matters: **launch nvim from inside the devshell**, not beside it. Language servers inherit the PATH of the process that spawns them, so `nix develop` then `nvim` gets the pinned toolchain, while `nvim` in another pane gets the host one and reports confusing errors.

Where it does break is Mason on NixOS or a Nix-built container: Mason downloads prebuilt dynamically-linked binaries that expect an FHS layout, and there is no `/lib64/ld-linux-*` to load them. On macOS this does not arise. If it ever does, drop `ensure_installed` in `lua/plugins/lsp.lua` and let the devshell provide the servers — `vim.lsp.enable()` picks up anything on PATH.
