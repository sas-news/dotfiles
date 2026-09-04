# justfile — Stage-1 management base (Option-A: Stow + just + mise)
# Forget-proof: bare `just` shows everything. See docs/adr-001-management-base.md.
# Install just if missing: sudo pacman -S just

# Default: show all recipes (forget-proof entry point).
default: help

# Show all recipes.
help:
    @just --list

# First-run setup: backup (~/.dotbackup) + link via legacy script.
# Wraps .bin/install.sh link_to_homedir() (backup old dotfiles, ln -snf loop, skip .git).
bootstrap:
    @echo "just bootstrap: bash .bin/install.sh"
    @bash .bin/install.sh

# Link per-package symlinks (fixes ~/.config shadowing vs whole-dir ln -snf).
link:
    @echo "just link: stow packages"
    @echo "TODO(T6): stow -R -t ~ packages/* (stow layout lands in a later wave; legacy path is just bootstrap)"

# Run environment checks.
doctor:
    @echo "just doctor: bash tests/doctor.sh"
    @test -f tests/doctor.sh && bash tests/doctor.sh || echo "tests/doctor.sh not yet present — basic checks only"
    @command -v stow >/dev/null && echo "stow: OK" || echo "stow: missing (Stage-1 needs stow)"
    @command -v mise >/dev/null && echo "mise: OK" || echo "mise: missing (Stage-1 needs mise)"
    @command -v just >/dev/null && echo "just: OK" || echo "just: missing (sudo pacman -S just)"

# Pull latest + re-link (Stage-1: git pull + link reminder).
sync:
    @echo "just sync: git pull --ff-only && just link"
    @git pull --ff-only
    @just link

# Clean stale/broken symlinks and backups reminder.
gc:
    @echo "just gc: prune broken symlinks under HOME"
    @find "$HOME" -maxdepth 1 -xtype l -print
    @echo "Remove with: find ~ -maxdepth 1 -xtype l -delete (review list above first)"
