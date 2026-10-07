# dotfiles

どっとふぁいる！(つくりかけ)

Management base: Option-A (Stow + just + mise). See `docs/adr-001-management-base.md`.
Stow packages live in `stow/` — zsh, nvim, tmux, ghostty, git, bin — each
mirroring `$HOME`-relative paths (e.g. `stow/zsh/.zshrc` -> `~/.zshrc`).

## Quickstart (Arch, single host)

```sh
# Install the runner if missing
sudo pacman -S just

# First run: backup conflicting targets (~/.dotbackup) + stow link + TPM plugins
just bootstrap

# Forget a command? Bare just lists everything
just
```

忘れたとき用: **[docs/cheatsheet.md](docs/cheatsheet.md)** に
ショートカット・エイリアス・場所メモを全部まとめてある。

## Everyday commands

| Command | What it does |
|---|---|
| `just` | Show all recipes (`just --list`) |
| `just bootstrap` | First-run setup: backup conflicts + `stow -R` + TPM + doctor |
| `just link` | Re-link all `stow/*` packages into `$HOME` |
| `just unlink` | Remove all stow links (rollback) |
| `just doctor` | Diagnose (`tests/doctor.sh` + `tests/stage2_verify.sh`) |
| `just sync` | `git pull --ff-only` + relink |
| `just gc` | List broken top-level symlinks under `$HOME` |
| `just tmux-setup` | Clone TPM if missing + install tmux plugins |
| `just pkg-diff` | Drift: `pacman -Qqe` vs `packages/pacman.txt` |
| `just upgrade` | Update mise tools + nvim + tmux plugins |

Fresh machine? `stow/bin/.bin/arch-setup.sh` runs the full order:
pacman manifest (`packages/pacman.txt`) -> mise trust/install ->
`just bootstrap` -> powerlevel10k clone.
