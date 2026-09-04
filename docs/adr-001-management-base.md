# ADR-001: Stage-1 Management Base

Status: Accepted
Date: 2026-09-04

## Context

Repo `/home/sasnews/dotfiles` has 8 tracked files. README.md is 2 lines (`# dotfiles` plus a draft note). Current setup uses `.bin/install.sh` `link_to_homedir()`, which loops `$dotdir/.??*` and runs `ln -snf` into `$HOME`.

That whole-dir symlink way causes the known `~/.config` problem: linking the full dir shadows everything else under `~/.config`. Stage-1 is management-first. Stage-2 rich zsh/nvim/tmux work is deferred to `docs/next-stage.md`.

Constraints (2026-09-04): single Arch Linux host, no Nix, no LLM plugins, free tools only, management-first, no package installs in this task.

## Decision

Winner: Option-A (Stow + just + mise). In full: Option A is the Stage-1 management base.

## Reasons (all decided 2026-09-04)

1. 2026-09-04: Per-package symlink control fixes the `~/.config` problem. Stow links files, not the whole dir, so app configs coexist.
2. 2026-09-04: `just` gives one entry point for `stow`, `unstow`, and checks. It replaces the ad hoc `ln -snf` loop with repeatable recipes.
3. 2026-09-04: `mise` pins free tool versions on single Arch Linux with no Nix and no extra cost. It keeps Stage-1 reproducible.
4. 2026-09-04: Management-first fits T1 blocking T4/T5/T6. Layout and tasks land before rich shell/editor config.

## Rejected

Option B (chezmoi): chezmoi is strong for templates and multi-machine secrets, but we don't need that here. Single Arch host, no secrets flow, and team knows plain symlink layout. It adds concepts without payoff for Stage-1.

Option C (symlink harden): keeping the current symlink script and hardening it would not fix the core flaw. A safer `ln -snf` loop is still whole-dir symlink behavior. It leaves `~/.config` conflicts in place.

## Rollback

If Option-A fails, rollback is plain symlink restore. Run the stow package uninstall (`stow -D`), then re-run `.bin/install.sh` to restore the old `ln -snf` links, or hand link the 8 tracked files. No data loss path: the script already backs up to `~/.dotbackup`. Date of this rollback plan: 2026-09-04.

## Stage-2 Compatibility

This ADR does not lock shell, editor, or multiplexer choice. Stage-2 (rich zsh/nvim/tmux per `docs/next-stage.md`) builds on top of the Stow package layout and just recipes defined here. No rework of the management base expected.
