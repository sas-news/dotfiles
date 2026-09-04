# AGENTS.md — dotfiles agent guide (Stage-1 management-first)

## First thing: diagnose before changing

Run `just doctor` first. It prints what is missing (stow/mise/just)
and runs `tests/doctor.sh` when present (guarded with `test -f`).

If `just` is not installed: `sudo pacman -S just` (Arch, single host).

Bare `just` (= `just --list`) shows every recipe. Forgetful human approved.

## Repo map

- `justfile` — single entry point. Recipes: `default` (= `help`),
  `bootstrap` (wraps `.bin/install.sh`), `link` (per-package stow),
  `doctor` (checks), `sync` (pull + relink), `gc` (prune dead links).
- `.bin/install.sh` — legacy linker. `link_to_homedir()` backs up to
  `~/.dotbackup`, skips `.git`, loops `$dotdir/.??*` with `ln -snf`.
  Whole-dir behavior shadows `~/.config`; stow packages replace it.
- `docs/adr-001-management-base.md` — Option-A decision
  (Stow + just + mise). Blocks T4/T5/T6. Rollback: `stow -D` then
  re-run `.bin/install.sh`.
- `docs/next-stage.md` — Stage-2 (zsh/nvim/tmux). Out of scope for Stage-1.
- `tests/doctor.sh` — health script (lands in T7; justfile guards its absence).
- `packages/` — stow layout (later wave; do not invent here).

## Commands

- `just` / `just --list` — show everything (start here).
- `just bootstrap` — first-run setup on this Arch host.
- `just doctor` — diagnose; run before and after any change.
- `just link` — re-link after editing stow packages.
- `just sync` — `git pull --ff-only` + relink.
- `just gc` — list broken top-level symlinks under `$HOME`.

## Commit rules

- Management-first, Stage-1 only. No rich shell/editor config here.
- Do NOT touch: `stow/` layout, `.gitignore`, `.zshrc` contents,
  `packages/` (other waves), Kiro blocks (out of scope).
- Do NOT `git commit` from automation unless the user asks.
- Keep recipes echoing their exact subcommand so `--show` stays honest.
- Verify with `just --summary` and `just --show doctor` after editing the justfile.
