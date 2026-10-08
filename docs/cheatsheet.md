# チートシート — 忘れたらここ

## まず打つコマンド

| 状況 | コマンド |
|---|---|
| コマンド忘れた | `just` （レシピ一覧が出る） |
| なんか調子悪い | `just doctor` （全部チェックしてくれる） |
| リンク直したい | `just link` |
| 全部剥がしたい | `just unlink` |
| 新マシン | `~/.bin/arch-setup.sh` |
| 壊れたリンク探す | `just gc` |
| 入れたpkgがマニフェスト未収録か | `just pkg-diff` |
| ツール/プラグイン全部更新 | `just upgrade` |

## 設定の変え方（最重要）

**`~/dotfiles/stow/` 以下を直接編集するだけ。即反映。**
`~/.zshrc` 等は全部 symlink なので、repo のファイルを直す = 本物を直す。
**新しいファイル/パッケージを足した時だけ `just link`**。

```
stow/zsh/.zshrc        -> ~/.zshrc
stow/nvim/.config/nvim -> ~/.config/nvim   (dirごとsymlink)
stow/ghostty/.config/ghostty -> ~/.config/ghostty
stow/tmux/.tmux.conf   -> ~/.tmux.conf
stow/git/.gitconfig    -> ~/.gitconfig (+~/.gitignore_global)
stow/ssh/.ssh/config   -> ~/.ssh/config    (ホスト別名だけ。鍵は入れない)
stow/bat/.config/bat   -> ~/.config/bat    (mochaテーマ)
stow/bin/.bin          -> ~/.bin           (arch-setup.sh 等)
```

バックアップは `~/.dotbackup/` に日付/ラベル付きで溜まる。消さない。

## zsh

| キー/コマンド | 動作 |
|---|---|
| `Ctrl-P` / `Ctrl-N` | 入力済みプレフィックスで履歴検索（例: `git` 打って Ctrl-P） |
| `Ctrl-T` | fzf でファイル挿入 |
| `Ctrl-R` | fzf で履歴検索 |
| `Alt-C` | fzf でディレクトリ移動 |
| `Tab` | 補完（fzf-tab がプレビュー付きで出る。cd 補完は eza 一覧） |
| `→` (右矢印) | 灰色のサジェストを確定（autosuggestions） |
| `cd <名前>` | zoxide のスマートジャンプ（行ったことあるdirに飛べる） |
| `dir名` だけ入力 | auto_cd（cd 不要で移動） |
| `cd -` して Tab | 過去の移動履歴から選択（auto_pushd） |
| `ls` / `ll` / `la` | eza に置き換わってる（`--icons` つき） |
| `..` / `...` | 上の階層へ |
| `zi` | zoxide 履歴を fzf で選んでジャンプ |
| `lg` | lazygit（git の TUI。mocha配色） |
| `y` | yazi ファイルマネージャー（抜けた場所に cd される） |
| `cheat` | このチートシートを glow で綺麗に開く |
| `pbcopy` / `pbpaste` | xsel のクリップボード |
| `man xxx` | bat で色付き表示 |
| `p10k configure` | プロンプトの見た目を再設定 |
| `ssh xxx` | 自動で TERM=xterm-256color に落とす（リモートに ghostty terminfo がなくても文字化けしない） |
| `fastfetch` | スペック+ロゴ表示（新しいシェルを開いた時に自動で出る。tmux ペイン内では出ない） |

`$EDITOR`/`$VISUAL` は nvim（sudoedit・crontab -e も nvim で開く）。

履歴は全シェル即時共有・100万件（`~/.local/share/zsh/history`）。
プラグイン管理は sheldon（`stow/zsh/.config/sheldon/plugins.toml`）。

## tmux （prefix = `Ctrl-b`）

| キー | 動作 |
|---|---|
| `prefix h j k l` | ペイン移動（vim式） |
| `prefix H J K L` | ペインリサイズ（連打可） |
| `prefix \|` | 縦分割（左右）※cwd引継ぎ |
| `prefix -` | 横分割（上下）※cwd引継ぎ |
| `prefix [` → `v` | コピーモード入って選択開始 |
| 選択中に `y` | ヤンク（ローカルはxsel、SSH越しはOSC52でローカルPCへ） |
| `prefix r` | .tmux.conf をリロード（再起動不要） |
| `prefix o` | sessionx: fzf ポップアップでセッション切替 |
| `prefix I` | TPM: プラグインをインストール（.tmux.conf編集後に打つ） |
| `prefix U` | TPM: プラグイン更新 |
| マウス | 全部有効（ペイン選択・スクロール・リサイズ） |

プラグイン追加 → `.tmux.conf` の `@plugin` 行を足して `prefix I`、
または `just tmux-setup`。

## nvim （leader = `Space`）

| キー | 動作 |
|---|---|
| `Space` 押して待つ | which-key が全部のキー一覧を出す（最強の思い出し手段） |
| `Space ff` | ファイル検索（fzf-lua） |
| `Space gg` | lazygit を新タブで開く |
| `Space fg` | 全文 grep |
| `Space fb` | バッファ一覧 |
| `Space fh` | ヘルプ検索 |
| `-` | oil.nvim で親ディレクトリ（ファイラ。oil内で `-` = 上へ、`Enter` = 開く、`g?` = ヘルプ） |
| `ys{対象}{文字}` | 囲む（surround。例: `ysiw"` = 単語を `"` で囲む） |
| `cs{旧}{新}` | 囲みを変更（`cs"'` = `"` → `'`） |
| `ds{文字}` | 囲みを削除（`ds"` = `"` を消す） |
| `Ctrl-y` | 補完ポップアップを確定（blink.cmp） |
| `Ctrl-n` / `Ctrl-p` | 補完候補を上下 |
| `:w` | 保存時に自動フォーマット（lua=stylua, py=ruff, js/ts/md=prettier） |
| `:Lazy` | プラグイン管理UI |
| `:Gitsigns` | git の hunk 操作（gutter の +/- 印はデフォルト表示） |

テーマは catppuccin mocha。LSP は nvim-lspconfig + `lua/lsp/servers.lua`。

## git

| エイリアス | 展開先 |
|---|---|
| `git st` | `status -sb`（短い状態表示） |
| `git lg` | `log --oneline --graph --decorate`（グラフ履歴） |
| `git br` | `branch -vv`（追跡先つきブランチ一覧） |
| `git sw` | `switch`（ブランチ切替） |

- `git diff` / `git log -p` は **delta** が表示: side-by-side + 行番号 + mocha色。diff 中 `n`/`N` で hunk ジャンプ
- TUI でやりたい → `lg`（lazygit。`Space`=stage, `c`=commit, `P`=push, `q`=終了, `?`=キー一覧）
- `git push` 等の https URL は自動で `git@github.com:` に書き換わる（SSH運用）
- 認証は `gh auth login` 一回でOK（credential helper が gh を使う）
- commit editor は nvim（無ければ nano → vi の順でフォールバック）
- グローバル ignore は `~/.gitignore_global`（node_modules/.env 等を全部のrepoで無視）

## ghostty

| キー | 動作 |
|---|---|
| `Ctrl-Shift-,` | 設定リロード |
| （その他） | 全部デフォルト。フォント pin `0xProto Nerd Font Mono` はコメント済みで眠ってる（config 末尾。有効化する時は `#` を外す） |

## 場所メモ

| 何が | どこ |
|---|---|
| repo | `~/dotfiles` |
| ツール pin（mise） | `~/dotfiles/mise.toml`（rg/fd/node/LSP系 + delta/lazygit/yazi/glow/fastfetch） |
| pacman マニフェスト | `~/dotfiles/packages/pacman.txt`（ズレは `just pkg-diff`） |
| sheldon プラグイン実体 | `~/.local/share/sheldon/`（lock もここ。repo には plugins.toml だけ） |
| yazi テーマ | `stow/yazi/.config/yazi/flavors/`（catppuccin-mocha 同梱） |
| powerlevel10k | `~/powerlevel10k`（repo外、arch-setup.sh がclone） |
| tmux プラグイン | `~/.tmux/plugins/`（TPM管理） |
| nvim プラグイン | `~/.local/share/nvim/lazy/`（lazy.nvim管理、ロックは `lazy-lock.json`） |
| バックアップ | `~/.dotbackup/` |
| このファイル | `~/dotfiles/docs/cheatsheet.md` |

## 迷子になった時の心構え

1. `just` で一覧 → `just doctor` で健康診断
2. リンクおかしい → `just link`
3. それでもダメ → `git status` で差分見る → 戻すなら `git checkout -- <file>` + `just link`
4. 新マシン/初期化 → `~/.bin/arch-setup.sh`（pacman→mise→bootstrap→p10k 全部やる）
