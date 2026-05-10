# CLAUDE.md - Dotfiles

Full system context is in [CONTEXT.md](CONTEXT.md). Read that first.

## What Goes Where

- **Stow-able configs** (user-level, `~/.config/`): Create proper directory structure, stow it
- **System configs** (`/etc/`, `/boot/`): Keep in repo as reference, document manual install in README
- **Secrets/credentials**: Never commit. Use `.gitignore`.
