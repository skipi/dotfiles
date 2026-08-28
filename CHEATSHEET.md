# Home Row

Keybindings for this config, plus the habits that make them pay off.

Leader is `<Space>`. tmux prefix is `Ctrl-a`. **When in doubt, press leader and wait** — which-key draws the rest of the menu for you.

---

## Start here

### The daily five

| Keys | Action |
|---|---|
| `<leader>ff` | Find a file by name |
| `<leader>fg` | Grep the whole project, live |
| `<leader><leader>` | Jump between open buffers |
| `gd` | Go to definition |
| `gr` | Every reference to this symbol |

### What moved since you last used vim

| Keys | Action |
|---|---|
| `-` | Opens the parent directory as an editable buffer — netrw is gone, this is oil |
| `s` | Jump anywhere on screen — use `cl` for the old substitute |
| `S` | Flash treesitter select — use `cc` for the old substitute-line |
| `K` | Hover docs from the language server, not man pages |
| `<Esc>` | Also clears search highlight |
| `J` / `K` *(visual)* | Move the selection up and down |

---

## Find

Telescope, backed by ripgrep and fd. Inside any picker: `Ctrl-j` / `Ctrl-k` to move, `Enter` to open, `Ctrl-q` to dump every result into the quickfix list, `Esc` to close.

### Files and buffers

| Keys | Action |
|---|---|
| `<leader>ff` | Find files (hidden included, `.git` excluded) |
| `<leader>fo` | Recently opened files |
| `<leader>fb` | Open buffers |
| `<leader><leader>` | Open buffers — the fast one |
| `<leader>fn` | Find inside your nvim config |
| `<leader>fr` | Reopen the last picker, where you left it |

### Text

| Keys | Action |
|---|---|
| `<leader>fg` | Live grep across the project |
| `<leader>fw` | Grep the word under the cursor |
| `<leader>fw` *(visual)* | Grep the current selection |
| `<leader>f/` | Fuzzy search within this buffer |

### Symbols and diagnostics

Needs a language server attached.

| Keys | Action |
|---|---|
| `<leader>fs` | Symbols in this file |
| `<leader>fS` | Symbols across the workspace |
| `<leader>fd` | Diagnostics in this buffer |
| `<leader>fD` | Diagnostics everywhere |

### Self-documenting

| Keys | Action |
|---|---|
| `<leader>fh` | Help tags — the whole vim manual, fuzzy |
| `<leader>fk` | Every keymap currently bound |
| `<leader>fc` | Every command |

---

## Read code

Language servers answer *where* and *what*; treesitter answers *which block*.

### Follow the code

All four jump targets open in Telescope, so you preview before committing.

| Keys | Action |
|---|---|
| `gd` | Definition |
| `gr` | References |
| `gi` | Implementations |
| `gy` | Type definition |
| `gD` | Declaration |
| `K` | Hover docs and signature |
| `Ctrl-o` | Back where you came from — built in, and the one to internalise |
| `Ctrl-i` | Forward again |

### Move by structure

| Keys | Action |
|---|---|
| `]f` / `[f` | Next / previous function |
| `]c` / `[c` | Next / previous class or module |
| `s` | Flash: type 2 chars, jump to any match on screen |
| `S` | Flash: select an enclosing syntax node |
| `za` | Toggle fold — folds follow syntax, not indent |

### Select by structure

Works after an operator (`d`, `y`, `c`) or in visual mode.

| Keys | Action |
|---|---|
| `af` / `if` | A whole function / a function body |
| `ac` / `ic` | A whole class / a class body |
| `aa` / `ia` | A parameter, with its comma / just the parameter |
| `a/` | A comment block |

### Lists worth living in

Trouble — persistent panes you navigate, not popups you dismiss.

| Keys | Action |
|---|---|
| `<leader>xs` | Symbol outline of this file |
| `<leader>xx` | All diagnostics |
| `<leader>xb` | Diagnostics, this buffer only |
| `<leader>xr` | References and definitions, as a pane |
| `<leader>xq` | The quickfix list |
| `<leader>xt` | Every TODO and FIXME in the project |

---

## Change code

Format-on-save is deliberately off — these repos gate formatting in CI and a stray reformat makes a noisy diff. Format when you mean to.

### Language server actions

| Keys | Action |
|---|---|
| `<leader>cr` | Rename symbol, project-wide |
| `<leader>ca` | Code action — imports, quick fixes |
| `<leader>cf` | Format the buffer |
| `<leader>cd` | Read the diagnostic on this line |

### Surround and comment

| Keys | Action |
|---|---|
| `gcc` | Comment this line |
| `gc` *(visual)* | Comment the selection |
| `gcif` | Comment out this whole function |
| `ysiw"` | Wrap the word in quotes |
| `cs"'` | Change surrounding quotes |
| `ds(` | Delete surrounding parentheses |

### Diagnostics

| Keys | Action |
|---|---|
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error, skipping warnings |

### Editing habits worth keeping

| Keys | Action |
|---|---|
| `p` *(visual)* | Paste over a selection without losing your register |
| `<leader>d` | Delete without touching the register |
| `<` / `>` *(visual)* | Re-indent and keep the selection |
| `<leader>w` | Write the file |
| `<leader>qq` | Quit all |

---

## Git

Gitsigns for the line-level work you do while reading; lazygit for anything involving a commit.

### In the buffer

| Keys | Action |
|---|---|
| `]h` / `[h` | Next / previous changed hunk |
| `<leader>gp` | Preview the hunk inline |
| `<leader>gr` | Reset the hunk |
| `<leader>gd` | Diff this file against HEAD |
| `<leader>gB` | Full blame for this line |
| `<leader>ub` | Toggle blame at end of every line |

### History and staging

| Keys | Action |
|---|---|
| `<leader>gg` | lazygit — stage, commit, rebase, resolve (`q` closes) |
| `<leader>gs` | Changed files, as a picker |
| `<leader>gc` | Project commit log |
| `<leader>gb` | Commits touching this file |

---

## Windows, buffers, panes

`Ctrl-h/j/k/l` crosses the boundary between a Neovim split and a tmux pane without you having to know which one you're in. That's the single best thing about running the two together.

### Neovim

| Keys | Action |
|---|---|
| `Ctrl-h` `Ctrl-j` `Ctrl-k` `Ctrl-l` | Move to the split or tmux pane in that direction |
| `<leader>\|` | Split right |
| `<leader>-` | Split below |
| `Ctrl-←/→/↑/↓` | Resize the split |
| `Shift-h` / `Shift-l` | Previous / next buffer |
| `<leader>bd` | Close this buffer |
| `<leader>bo` | Close every other buffer |
| `<leader>t` | Terminal in a split |
| `<Esc><Esc>` *(terminal)* | Leave terminal mode |

### Files, without a sidebar

oil.nvim: a directory is just a buffer. Edit it and write.

| Keys | Action |
|---|---|
| `-` | Open the parent directory |
| `<leader>e` | Same thing, floating |
| `dd` | Delete a file — it's a buffer, so this is just `dd` |
| `cw` | Rename a file |
| `:w` | Apply every pending file change |
| `q` | Close oil |

### tmux

Prefix is `Ctrl-a`. Press it, release, then the key.

| Keys | Action |
|---|---|
| `Ctrl-a f` | Jump to any repo, worktree or project as a session |
| `Ctrl-a s` | Session and window tree |
| `Ctrl-a \|` | Split right, same directory |
| `Ctrl-a -` | Split below, same directory |
| `Ctrl-a c` | New window |
| `Ctrl-a m` | Zoom this pane full-screen, and back |
| `Ctrl-a g` | lazygit in a new window |
| `Ctrl-a H/J/K/L` | Resize the pane, repeatable |
| `Ctrl-a r` | Reload tmux.conf |
| `Ctrl-a a` | Send a literal `Ctrl-a` — start of line in zsh |

### tmux copy mode

Vi keys. This is how you scroll back.

| Keys | Action |
|---|---|
| `Ctrl-a Enter` | Enter copy mode |
| `v` | Start selecting |
| `Ctrl-v` | Block selection |
| `y` | Yank to the macOS clipboard |
| `/` | Search the scrollback |
| `Esc` | Leave copy mode |

---

## Toggles and upkeep

### Toggles

`<leader>u` is the "user interface" group.

| Keys | Action |
|---|---|
| `<leader>uh` | Inlay hints — inferred types, inline |
| `<leader>ub` | Git blame on every line |
| `<leader>ud` | Diagnostics on / off |
| `<leader>uw` | Line wrap |
| `<leader>us` | Spell check |

### Commands to know

| Command | Action |
|---|---|
| `:Lazy` | Plugins. `U` update, `S` sync, `x` clean, `?` help |
| `:Mason` | Language servers and formatters |
| `:TSUpdate` | Treesitter parsers — after any plugin update |
| `:checkhealth` | First stop when anything misbehaves |
| `:LspInfo` | Which servers attached to this buffer |
| `:ConformInfo` | Which formatter would run here |

---

## Getting the habit back

**Press leader and wait.** which-key draws a menu of everything available from whatever you've typed so far. That makes the config self-teaching: you never have to remember a full sequence, only its first letter. `f` is find, `c` is code, `g` is git, `x` is lists, `u` is toggles, `b` is buffers. `<leader>fk` fuzzy-searches every binding by description when the menu isn't enough.

**Stop opening files by path.** The habit that pays off fastest: never type a path again. `<leader>ff` and three characters of a filename beats any tree. Across 25 repos this is the difference between the editor feeling fast and feeling like an obstacle. When you don't know the filename, you almost always know a string that's in it — that's `<leader>fg`.

**Learn `Ctrl-o` before anything else.** `gd` is only useful if coming back is free. `Ctrl-o` walks back through the jump list, `Ctrl-i` walks forward. Once that pair is automatic, you'll read code by diving three definitions deep and popping straight back out.

**Send search results to the quickfix list.** In any Telescope picker, `Ctrl-q` dumps every result into the quickfix list. Then `:cdo s/old/new/g | update` runs a substitution across all of them. That's the project-wide refactor that doesn't need an IDE — and it's still the fastest way to do a mechanical rename that a language server won't handle.

**Treat the config as a live document.** `<leader>fn` jumps into the config from anywhere. When a binding annoys you, change it that minute — it's ~620 lines and you own all of them. Edits to `lua/` apply on restart; `:Lazy` handles plugin changes. Every mapping lives in one file, `lua/config/keymaps.lua`.

**One tmux session per repo.** `Ctrl-a f` fuzzy-jumps to any repo, worktree or project and gives it its own session, creating it if needed. Sessions persist, so the editor, a shell and a test runner stay exactly where you left them per project. Worktrees get compound names like `billing__credits-crud`, so branches of the same repo never collide.

**Let the language server do the renaming.** `<leader>cr` renames across the project properly — it understands scope, so it won't touch a same-named variable in an unrelated module. Reach for it before reaching for grep-and-replace.

**Read with structure, not line numbers.** `]f` hops function to function. `<leader>xs` opens an outline of the file. `vaf` selects the whole function so you can yank it into a prompt. In an unfamiliar Elixir or Go file these three beat scrolling every time.

---

## Two things to know about the setup itself

`ruby_lsp` runs `bundle install` in a project the first time it attaches — in a repo whose gems aren't installed locally it will fail until you run `bundle install` there yourself.

`stylua` is excluded from Mason's automatic LSP enabling on purpose: Mason maps it to a `stylua --lsp` server that duplicates what conform already does, and having both attached is confusing.

### Adding a plugin

One file in `nvim/lua/plugins/` returning a table of specs; lazy.nvim imports the directory.

```lua
return {
  {
    "owner/repo",
    dependencies = { "other/repo" },
    event = "BufReadPre",           -- lazy-load trigger: event | ft | cmd | keys
    opts = {},                      -- lazy calls require("repo").setup(opts)
    -- config = function() ... end, -- INSTEAD of opts when you need logic
    -- init   = function() ... end, -- runs at startup, before the plugin loads
  },
}
```

Keymaps go in `lua/config/keymaps.lua`, not the spec's `keys` — that is the point of this config. Commit `lazy-lock.json` afterwards to pin versions.

Before adding anything treesitter- or LSP-adjacent, check it isn't written for the old APIs:

```sh
git clone --depth 1 <repo> /tmp/p && grep -rn \
  -e get_parser_configs -e 'nvim-treesitter.configs' \
  -e "require('lspconfig')" -e 'require("lspconfig")' /tmp/p
```

Any hit means it targets nvim-treesitter `master` or pre-0.11 LSP, and will break here.
