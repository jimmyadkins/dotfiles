# CLAUDE.md — dotfiles repo

Instructions for Claude Code when working in this chezmoi-managed dotfiles repository.

## Chezmoi conventions

- Source files live in `~/.local/share/chezmoi/` — **never edit deployed files directly**
- Chezmoi filename prefixes: `dot_` → `.`, `executable_` → sets +x, `private_` → mode 600, `.tmpl` → Go template
- After editing a source file, run `chezmoi apply` to deploy it
- To track a modified home-dir file: `chezmoi add <file>`

## Template variables

Templates branch on `.machineType` which is either `"personal"` or `"work"`. When modifying `.tmpl` files, preserve both branches unless the change applies to both.

## File map

```
dot_zshrc.tmpl              → ~/.zshrc
dot_gitconfig.tmpl          → ~/.gitconfig
dot_Brewfile.tmpl           → ~/.Brewfile
dot_tmux.conf               → ~/.tmux.conf
dot_tmux/                   → ~/.tmux/
dot_config/nvim/            → ~/.config/nvim/
dot_config/aerospace/       → ~/.config/aerospace/
dot_config/sketchybar/      → ~/.config/sketchybar/
dot_config/wezterm/         → ~/.config/wezterm/
dot_config/yazi/            → ~/.config/yazi/
dot_config/starship/        → ~/.config/starship/
```

## Security — this is a PUBLIC repository

**Never commit sensitive data.** Before adding or modifying any file, check for:

- API keys, tokens, passwords, or secrets of any kind
- SSH private keys or certificates
- Personal email addresses or real names beyond what's already present
- Hostnames, IPs, or internal network details
- Machine-specific paths that reveal account names (use `$HOME` or chezmoi variables instead)
- Anything inside `private_` prefixed files — chezmoi marks these as mode 600 locally but they are still stored in plaintext in the repo

If a value must exist in a config file, move it to a chezmoi secret or template variable rather than hardcoding it. Use `chezmoi secret` or store sensitive values in `~/.config/chezmoi/chezmoi.toml` (which is **not** tracked) and reference them via `{{ .variableName }}` in templates.

When in doubt, do not commit — ask first.

## Workflow

1. Make changes in the chezmoi source directory (`~/.local/share/chezmoi/`)
2. Run `chezmoi apply` to deploy
3. Commit from the source directory (not `~`)
4. Push to `origin` (GitHub)

## Commit style

Follow the existing commit convention: gitmoji prefix + conventional commit type + description.
Examples: `✨ feat: ...`, `🐛 fix: ...`, `🔧 chore: ...`, `📚 docs: ...`
