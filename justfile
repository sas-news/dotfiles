# justfile — management base (Option-A: Stow + just + mise)
# Forget-proof: bare `just` shows everything. See docs/adr-001-management-base.md.
# Install just if missing: sudo pacman -S just

# Default: show all recipes (forget-proof entry point).
default: help

# Show all recipes.
help:
    @just --list

# First-run setup: deps check -> backup conflicting targets to ~/.dotbackup -> stow -R -> TPM plugins -> doctor.
bootstrap:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "just bootstrap: deps -> backup ~/.dotbackup -> stow -R -> tmux-setup -> doctor"
    for t in stow just; do
        command -v "$t" >/dev/null || { echo "missing: $t (install via packages/pacman.txt)" >&2; exit 1; }
    done
    STOW_ROOT="$(realpath stow)"
    is_ours() {
        # true when target resolves into this repo — covers leaf links AND
        # real files reached through a parent dir symlink (e.g. ~/.config/nvim
        # -> stow pkg dir makes ~/.config/nvim/* resolve inside the repo).
        # Anchored on this clone's stow dir, not the literal name "dotfiles" —
        # a renamed checkout must still be recognized as ours (mv guts the repo).
        case "$(realpath -m "$1" 2>/dev/null)" in "$STOW_ROOT"/*) return 0 ;; esac
        return 1
    }
    BKROOT="$HOME/.dotbackup/bootstrap-$(date +%Y%m%d-%H%M%S)"
    moved=0
    pkgs=()
    for d in stow/*/; do pkgs+=("${d%/}"); done
    for pkg in "${pkgs[@]}"; do
        while IFS= read -r -d '' src; do
            rel="${src#"$pkg"/}"
            target="$HOME/$rel"
            if [ -d "$src" ] && [ ! -L "$src" ]; then
                # package dir: stow unfolds real dirs; conflicts only when target
                # exists as a non-dir or a foreign symlink
                if { [ -e "$target" ] && [ ! -d "$target" ]; } || { [ -L "$target" ] && ! is_ours "$target"; }; then
                    mkdir -p "$BKROOT/$(dirname "$rel")"
                    mv "$target" "$BKROOT/$rel"
                    moved=1
                fi
            elif [ -e "$target" ] || [ -L "$target" ]; then
                # package file: conflict unless already linked to this repo
                if ! is_ours "$target"; then
                    mkdir -p "$BKROOT/$(dirname "$rel")"
                    mv "$target" "$BKROOT/$rel"
                    moved=1
                fi
            fi
        done < <(find "$pkg" -mindepth 1 -print0)
    done
    [ "$moved" -eq 1 ] && echo "conflicts backed up to $BKROOT" || true
    for pkg in "${pkgs[@]}"; do
        p="${pkg#stow/}"
        echo "stow -d stow -R -t ~ $p"
        stow -d stow -R -t "$HOME" "$p"
    done
    just tmux-setup
    just doctor

# Re-link all stow packages into $HOME (idempotent restow).
link:
    @echo "just link: stow -d stow -R -t ~ <each package under stow/>"
    @for d in stow/*/; do p="${d%/}"; p="${p#stow/}"; echo "stow: $p"; stow -d stow -R -t "$HOME" "$p"; done

# Unlink all stow packages from $HOME (rollback; see docs/adr-001-management-base.md).
unlink:
    @echo "just unlink: stow -d stow -D -t ~ <each package under stow/>"
    @for d in stow/*/; do p="${d%/}"; p="${p#stow/}"; echo "stow -D: $p"; stow -d stow -D -t "$HOME" "$p"; done

# Run environment checks (tests/doctor.sh + tests/stage2_verify.sh + toolchain).
doctor:
    @echo "just doctor: bash tests/doctor.sh && bash tests/stage2_verify.sh"
    @if [ -f tests/doctor.sh ]; then bash tests/doctor.sh; else echo "tests/doctor.sh missing"; exit 1; fi
    @if [ -f tests/stage2_verify.sh ]; then bash tests/stage2_verify.sh; else echo "tests/stage2_verify.sh missing"; exit 1; fi
    @command -v stow >/dev/null && echo "stow: OK" || { echo "stow: missing (sudo pacman -S stow)"; exit 1; }
    @command -v mise >/dev/null && echo "mise: OK" || echo "mise: missing"
    @command -v just >/dev/null && echo "just: OK" || { echo "just: missing (sudo pacman -S just)"; exit 1; }

# Drift check: explicitly-installed pacman pkgs vs curated packages/pacman.txt.
pkg-diff:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "just pkg-diff: pacman -Qqe vs packages/pacman.txt"
    manifest() { sed 's/[[:space:]]*#.*//; /^[[:space:]]*$/d' packages/pacman.txt | sort -u; }
    echo "== installed, NOT in manifest (curate or ignore) =="
    comm -23 <(pacman -Qqe | sort) <(manifest)
    echo "== in manifest, NOT installed =="
    comm -13 <(pacman -Qqe | sort) <(manifest)

# Upgrade everything managed here: mise tools + nvim plugins + tmux plugins.
upgrade:
    @echo "just upgrade: mise upgrade && nvim Lazy! sync && tpm update_plugins all"
    @mise upgrade
    @nvim --headless "+Lazy! sync" +qa
    @~/.tmux/plugins/tpm/bin/update_plugins all || true

# Pull latest + re-link (git pull --ff-only && just link).
sync:
    @echo "just sync: git pull --ff-only && just link"
    @git pull --ff-only
    @just link

# Clean stale/broken symlinks and backups reminder.
gc:
    @echo "just gc: prune broken symlinks under HOME"
    @find "$HOME" -maxdepth 1 -xtype l -print
    @echo "Remove with: find ~ -maxdepth 1 -xtype l -delete (review list above first)"

# Install tmux plugins via TPM (clone TPM if missing, sudo-free).
tmux-setup:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "just tmux-setup: clone TPM if missing -> install_plugins"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        echo "TPM already present, skipping clone"
    fi
    echo "~/.tmux/plugins/tpm/bin/install_plugins"
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
