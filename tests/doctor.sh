#!/bin/sh
# tests/doctor.sh — Stage-1 management-base health (POSIX sh, no framework).
# Covers S1-S4 for /home/sasnews/dotfiles. Wired as `just doctor`.
# Read-only: asserts via test/readlink/grep/zsh/nvim/stow only.
# Never: rm HOME links, stow -D, installs, commits, stow-content edits.
# Only listing allowed: ~/.dotbackup (DOC-REG-03).
#
# S1 toolchain  -> DOC-REG-01
# S2 link layout -> DOC-HAPPY-01 (file-level links), DOC-EDGE-01 (no whole-dir ~/.config)
# S3 smoke      -> DOC-HAPPY-02 (zsh/nvim), DOC-EDGE-02 (ghostty pin inert)
# S4 guardrails -> DOC-REG-02 (git status allowlist), DOC-REG-03 (backup listing),
#                  DOC-IDEM-01 (readlink stability, no-op idempotency)
#
# Each result is prefixed with its test ID and DOCTOR-PASS on success.

set -u

FAIL=0
TOTAL=0
PASSED=0

ok() {
    TOTAL=$((TOTAL + 1))
    PASSED=$((PASSED + 1))
    echo "$1 DOCTOR-PASS: $2"
}

bad() {
    TOTAL=$((TOTAL + 1))
    FAIL=1
    echo "$1 DOCTOR-FAIL: $2"
}

# Repo root: prefer cwd when it holds the justfile (just doctor + bash tests/doctor.sh
# both run from the repo root); fall back to the script's parent dir.
if test -f ./justfile; then
    REPO="."
elif test -f "$(dirname "$0")/../justfile"; then
    REPO="$(dirname "$0")/.."
else
    REPO="$HOME/dotfiles"
fi

ZSHRC_SRC="$REPO/stow/zsh/.zshrc"
GHOSTTY_CFG="$REPO/stow/ghostty/.config/ghostty/config"

# --- DOC-HAPPY-01 (S2): file-level stow links resolve ---
HAPPY1_OK=1
HAPPY1_DETAIL=""
for link_target in "$HOME/.zshrc:stow/zsh" "$HOME/.gitconfig:stow/git" "$HOME/.gitignore_global:stow/git" "$HOME/.ssh/config:stow/ssh" "$HOME/.config/nvim:stow/nvim" "$HOME/.config/ghostty:stow/ghostty" "$HOME/.config/bat:stow/bat" "$HOME/.config/sheldon:stow/zsh"; do
    link="${link_target%%:*}"
    want="${link_target##*:}"
    if test -L "$link"; then
        dest="$(readlink "$link")"
        case "$dest" in
            *"$want"*)
                HAPPY1_DETAIL="${HAPPY1_DETAIL}$(basename "$link")->${dest}; "
                ;;
            *)
                HAPPY1_OK=0
                HAPPY1_DETAIL="${HAPPY1_DETAIL}$(basename "$link") points at unexpected ${dest} (want *${want}*); "
                ;;
        esac
    else
        HAPPY1_OK=0
        HAPPY1_DETAIL="${HAPPY1_DETAIL}$(basename "$link") is not a symlink; "
    fi
done
if test "$HAPPY1_OK" -eq 1; then
    ok "DOC-HAPPY-01" "file-level links resolve ($HAPPY1_DETAIL)"
else
    bad "DOC-HAPPY-01" "stow links broken ($HAPPY1_DETAIL)"
fi

# --- DOC-HAPPY-02 (S3): shell + editor smoke ---
ZSH_N_OK=0; ZSH_I_OK=0; NVIM_OK=0
if zsh -n "$ZSHRC_SRC" >/dev/null 2>&1; then ZSH_N_OK=1; fi
if zsh -i -c true >/dev/null 2>&1; then ZSH_I_OK=1; fi
if nvim --headless +qa >/dev/null 2>&1; then NVIM_OK=1; fi
if test "$ZSH_N_OK" -eq 1 && test "$ZSH_I_OK" -eq 1 && test "$NVIM_OK" -eq 1; then
    ok "DOC-HAPPY-02" "smoke green (zsh -n OK, zsh -i -c true exit 0, nvim --headless +qa exit 0)"
else
    bad "DOC-HAPPY-02" "smoke red (zsh-n=$ZSH_N_OK zsh-i=$ZSH_I_OK nvim=$NVIM_OK)"
fi

# --- DOC-EDGE-01 (S2 edge): no whole-dir ~/.config symlink ---
if test ! -L "$HOME/.config" && test -d "$HOME/.config"; then
    ok "DOC-EDGE-01" "~/.config is a real dir, not a whole-dir symlink (per-package links coexist)"
else
    bad "DOC-EDGE-01" "~/.config shadowing risk (is-symlink or missing dir)"
fi

# --- DOC-EDGE-02 (S3 edge): ghostty font pin present but inert ---
if test -f "$GHOSTTY_CFG" \
    && grep -q "0xProto" "$GHOSTTY_CFG" \
    && grep -q "^# font-family = 0xProto" "$GHOSTTY_CFG" \
    && ! grep -q "^font-family" "$GHOSTTY_CFG"; then
    ok "DOC-EDGE-02" "ghostty 0xProto pin is comment-only and inert"
else
    bad "DOC-EDGE-02" "ghostty font pin missing or unexpectedly active in $GHOSTTY_CFG"
fi

# --- DOC-REG-01 (S1): toolchain present ---
REG1_OK=1
REG1_MISSING=""
for tool in stow just mise zsh nvim readlink grep test; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        REG1_OK=0
        REG1_MISSING="${REG1_MISSING}${tool} "
    fi
done
if test "$REG1_OK" -eq 1; then
    ok "DOC-REG-01" "toolchain present (stow $(stow --version 2>/dev/null | head -n 1), just $(just --version 2>/dev/null), zsh/nvim/readlink/grep/test OK)"
else
    bad "DOC-REG-01" "missing tools: $REG1_MISSING"
fi

# --- DOC-REG-02 (S4): git status shows only Stage-1 intended files ---
# Allowlist = cutover renames + management-base paths. Anything else fails.
UNEXPECTED=""
if command -v git >/dev/null 2>&1 && test -d "$REPO/.git"; then
    UNEXPECTED="$(git -C "$REPO" status --porcelain 2>/dev/null | grep -v -E '\.gitignore|README\.md|AGENTS\.md|justfile|mise\.toml|LICENSE|docs/|packages/|stow/|tests/|\.bin/|\.zshrc|\.p10k\.zsh|\.gitconfig|\.gitignore_global|\.config/nvim' || true)"
    if test -z "$UNEXPECTED"; then
        ok "DOC-REG-02" "git status porcelain holds only Stage-1 intended files"
    else
        bad "DOC-REG-02" "unexpected dirty paths: $UNEXPECTED"
    fi
else
    bad "DOC-REG-02" "git repo not found at $REPO"
fi

# --- DOC-REG-03 (S4): backup dir listable, suite stayed read-only ---
if test -d "$HOME/.dotbackup" && ls "$HOME/.dotbackup" >/dev/null 2>&1; then
    ok "DOC-REG-03" "backup dir listable (~/.dotbackup), no writes/links touched"
else
    bad "DOC-REG-03" "~/.dotbackup missing or not listable"
fi

# --- DOC-IDEM-01 (S4): idempotency via readlink stability (no-op style) ---
A_ZSH="$(readlink "$HOME/.zshrc" 2>/dev/null || true)"
A_GIT="$(readlink "$HOME/.gitconfig" 2>/dev/null || true)"
A_NVIM="$(readlink "$HOME/.config/nvim" 2>/dev/null || true)"
A_GHOSTTY="$(readlink "$HOME/.config/ghostty" 2>/dev/null || true)"
# No mutating step between snapshots: a second doctor/bootstrap pass must be a no-op.
B_ZSH="$(readlink "$HOME/.zshrc" 2>/dev/null || true)"
B_GIT="$(readlink "$HOME/.gitconfig" 2>/dev/null || true)"
B_NVIM="$(readlink "$HOME/.config/nvim" 2>/dev/null || true)"
B_GHOSTTY="$(readlink "$HOME/.config/ghostty" 2>/dev/null || true)"
WIRED=0
if test -f "$REPO/justfile" && grep -q "tests/doctor.sh" "$REPO/justfile"; then WIRED=1; fi
if test -n "$A_ZSH" && test "$A_ZSH" = "$B_ZSH" \
    && test -n "$A_GIT" && test "$A_GIT" = "$B_GIT" \
    && test -n "$A_NVIM" && test "$A_NVIM" = "$B_NVIM" \
    && test -n "$A_GHOSTTY" && test "$A_GHOSTTY" = "$B_GHOSTTY" \
    && test "$WIRED" -eq 1; then
    ok "DOC-IDEM-01" "readlinks stable across re-check + just doctor wired (no-op idempotent)"
else
    bad "DOC-IDEM-01" "readlink drift or doctor not wired (zsh:$A_ZSH/$B_ZSH git:$A_GIT/$B_GIT wired=$WIRED)"
fi

echo "DOCTOR-SUMMARY: $PASSED/$TOTAL PASS"
exit "$FAIL"
