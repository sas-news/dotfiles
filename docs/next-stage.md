# Stage-2 — ACTIVATED

Status: **Done** (landed across 2026-09-05..07 commits; verified 2026-10-07).
`just doctor` runs `tests/stage2_verify.sh` — 7/7 checks pass.
Host context: Nvim 0.12.x / zsh 5.9.x / Ghostty truecolor / 0xProto present.

This file was originally the Stage-2 plan ("bridge stubs, inert — T9").
Everything listed below is now live. Kept as a map of what landed where.

## zsh — landed

- `stow/zsh/.zshrc`: powerlevel10k + instant prompt, XDG `HISTFILE`
  (`$XDG_STATE_HOME/zsh/history`), `mise activate zsh`.
- Guarded Stage-2 block (active, terminal-gated): `sheldon source`,
  `fzf --zsh` + Arch key-bindings/completion, fd-backed FZF defaults with
  mocha colors + bat/eza preview, fzf-tab previews, `zoxide init --cmd cd`,
  `eza` aliases (`ls`/`ll`/`la`).
- `stow/zsh/.p10k.zsh` and `stow/zsh/.config/sheldon/plugins.toml` stowed.

## nvim — landed

- `stow/nvim/.config/nvim/`: `init.lua` + `lua/` split — `config/`
  (options, keymaps, autocmds), `plugins/` (core, ui, edit, fzf, lsp,
  completion, treesitter, tools, which-key), `lsp/servers.lua`,
  `lazy-lock.json` pinned.
- `lua/stage2_bridge.lua` still exists as a comment-only inert stub —
  historical leftover, safe to delete whenever.

## tmux — landed

- `stow/tmux/.tmux.conf`: TPM auto-clone, `tmux-256color` + Ghostty `Tc`
  truecolor overrides, mouse on, vi copy-mode, catppuccin `mocha` status,
  `tmux-yank` with OSC52 passthrough for SSH clipboard.
- `just tmux-setup` clones TPM + installs plugins (idempotent).

## ghostty — still inert by design

- `stow/ghostty/.config/ghostty/config` keeps the font pin commented:
  `# font-family = 0xProto Nerd Font Mono`. DOC-EDGE-02 asserts it stays
  inert; flip it to active deliberately, not by accident.

## Verification

```sh
just doctor   # doctor.sh 8 checks + stage2_verify.sh 7 checks
```
