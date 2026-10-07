# AGENTS.md — dotfiles agent guide (Stow + just + mise)

## First thing: diagnose before changing

Run `just doctor` first. It runs `tests/doctor.sh` + `tests/stage2_verify.sh`
(both must pass) and prints missing tools (stow/mise/just).

If `just` is not installed: `sudo pacman -S just` (Arch, single host).

Bare `just` (= `just --list`) shows every recipe. Forgetful human approved.

## Repo map

- `justfile` — single entry point. Recipes: `default` (= `help`),
  `bootstrap` (deps check + backup conflicts to `~/.dotbackup` +
  `stow -R` + TPM + doctor), `link`/`unlink` (`stow -R`/`-D` over every
  `stow/*/` package), `doctor` (both test suites), `sync`
  (`git pull --ff-only` + relink), `gc` (list broken `~/` symlinks),
  `tmux-setup` (TPM clone + plugin install), `pkg-diff` (pacman manifest
  drift), `upgrade` (mise + lazy.nvim + TPM update).
- `stow/` — THE package layout: `bat`, `bin`, `ghostty`, `git`, `nvim`,
  `ssh`, `tmux`, `zsh`. Each package mirrors `$HOME`-relative paths
  (`stow/nvim/.config/nvim` -> `~/.config/nvim`). New packages need a
  whitelist pair in `.gitignore` (`!/stow/<pkg>/` + `!/stow/<pkg>/**`).
- `stow/bin/.bin/` — scripts stowed to `~/.bin`:
  `install.sh` = deprecated shim (exits 1, whole-dir `ln -snf` retired),
  `arch-setup.sh` = fresh-machine order (pacman manifest -> mise ->
  `just bootstrap` -> powerlevel10k clone).
- `packages/pacman.txt` — curated pacman manifest only. NOT stow packages.
- `tests/doctor.sh`, `tests/stage2_verify.sh` — health suites wired into
  `just doctor`.
- `docs/adr-001-management-base.md` — Option-A decision (2026-09-04).
  Rollback path today: `just unlink` (the `.bin/install.sh` mentioned in
  the ADR is the retired shim).
- `docs/cheatsheet.md` — human cheat sheet (shortcuts, aliases, paths).
  Update it whenever you change keybindings, aliases, or recipes.
- `docs/config-inventory.md` — `.config` survey (historical; the legacy
  in-repo `.config/` was retired to `~/.dotbackup` 2026-10-07).
- `docs/next-stage.md` — Stage-2 plan, now activated.

## Commands

- `just` / `just --list` — show everything (start here).
- `just doctor` — diagnose; run before and after any change.
- `just bootstrap` — setup on this Arch host.
- `just link` / `just unlink` — restow / remove stow links.
- `just sync` — `git pull --ff-only` + relink.
- `just gc` — list broken top-level symlinks under `$HOME`.
- `just pkg-diff` — drift between `pacman -Qqe` and `packages/pacman.txt`.
- `just upgrade` — mise + nvim (lazy) + tmux (TPM) updates in one go.

## Commit rules

- Do NOT `git commit` from automation unless the user asks.
- Do NOT touch `.gitignore` — it is a whitelist (`/*` + `!/` re-includes);
  new tracked top-level paths must be re-included there.
- Keep recipes echoing their exact subcommand so `--show` stays honest.
- `bootstrap` moves conflicting `$HOME` targets into `~/.dotbackup` —
  never delete `~/.dotbackup` contents from automation.
- `.zshrc` has Kiro blocks pinned at top and bottom — keep them in place.
- Verify justfile edits with `just --summary` + `just --show <recipe>`,
  then `just doctor`.

## Gotchas

- `~/.config/nvim` and `~/.config/ghostty` are DIR symlinks into the repo:
  `~/.config/nvim/x` resolves inside `dotfiles/stow/...`. Any `$HOME`
  existence check must use `realpath -m` (see `is_ours` in `justfile`
  bootstrap) — a leaf `-L` test mistakes repo files for foreign targets
  and `mv` will gut the repo. (Bit us once, 2026-10-07.)
- In recipes, `a && b || echo` swallows b's failure — use explicit
  `if/else` so `just doctor` exits non-zero on real failures.
