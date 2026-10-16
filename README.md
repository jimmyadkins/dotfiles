# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Targets macOS with a tiling WM setup built around Neovim.

## Setup

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jimmyadkins
```

Then install packages:

```sh
brew bundle --file ~/.Brewfile
```

## What's included

| Config | Tool | Notes |
|--------|------|-------|
| `.zshrc` | Zsh | Minimal config with autosuggestions, syntax highlighting, zsh-vi-mode |
| `.gitconfig` | Git | Rebase-on-pull, credential manager |
| `.Brewfile` | Homebrew | Machine-type conditional installs (`personal` vs `work`) |
| `.config/nvim/` | Neovim | Kickstart-based config with custom plugins |
| `.config/sketchybar/` | Sketchybar | macOS status bar with native desktop (Space) indicators |
| `.config/ghostty/` | Ghostty | Terminal emulator with native tabs and splits |
| `.config/wezterm/` | WezTerm | Previous terminal emulator |
| `.config/zellij/` | Zellij | Persistent sessions, mainly on remote hosts |
| `.config/yazi/` | Yazi | Terminal file manager |
| `.config/starship/` | Starship | Shell prompt |
| `.tmux.conf` | tmux | With TPM plugin manager |
| `run_onchange_after_macos-spaces.sh` | macOS | Fixed desktop order, Option+1–9 to switch desktops |

## Machine types

Chezmoi templates branch on `.machineType` (`personal` or `work`):

- **personal** — full toolchain including Azure CLI, Databricks, Snowflake, media tools, Obsidian, etc.
- **work** — minimal base set only

Set on init:

```sh
chezmoi init --apply jimmyadkins
# chezmoi will prompt for machineType
```

Or edit `~/.config/chezmoi/chezmoi.toml` directly:

```toml
[data]
  machineType = "personal"
```

## Key tools

- **Editor**: Neovim (kickstart.nvim base)
- **Terminal**: Ghostty
- **Multiplexer**: Zellij (remote sessions), tmux + TPM
- **Shell**: Zsh + Starship prompt
- **Windows**: native macOS desktops + Rectangle
- **Status bar**: Sketchybar
- **File manager**: Yazi
- **Git TUI**: Lazygit
- **AI**: Claude Code

## Updating

```sh
chezmoi update          # pull latest and apply
chezmoi add <file>      # track a new or modified file
chezmoi diff            # preview pending changes
chezmoi apply           # apply source state to home dir
```
