# dotfiles
どっとふぁいる！(つくりかけ)

Stage-1 management base: Option-A (Stow + just + mise).
See `docs/adr-001-management-base.md`. Rich shell/editor setup is Stage-2
(`docs/next-stage.md`).

## Quickstart (Arch, single host)

```sh
# Install the runner if missing
sudo pacman -S just

# First run: backup (~/.dotbackup) + link
just bootstrap

# Forget a command? Bare just lists everything
just
```

## Everyday commands

| Command | What it does |
|---|---|
| `just` | Show all recipes (`just --list`) |
| `just bootstrap` | First-run setup (wraps `.bin/install.sh`) |
| `just link` | Re-link per-package symlinks |
| `just doctor` | Diagnose environment (run first when lost) |
| `just sync` | `git pull --ff-only` + relink |
| `just gc` | List broken top-level symlinks under `$HOME` |

Legacy path: `bash .bin/install.sh` (whole-dir `ln -snf`; shadows
`~/.config` — stow packages replace it).
