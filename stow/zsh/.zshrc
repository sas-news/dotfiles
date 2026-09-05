
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=ja_JP.UTF-8

if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit -u

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # 補完候補で、大文字・小文字を区別しないで補完出来るようにするが、大文字を入力した場合は区別する
zstyle ':completion:*' ignore-parents parent pwd ..    # ../ の後は今いるディレクトリを補間しない
zstyle ':completion:*:default' menu select=1           # 補間候補一覧上で移動できるように
zstyle ':completion:*:cd:*' ignore-parents parent pwd  # 補間候補にカレントディレクトリは含めない

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/share}/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=1000000
SAVEHIST=1000000

setopt share_history           # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_all_dups    # 同じコマンドをhistoryに残さない
setopt hist_ignore_space       # historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks      # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups       # 重複するコマンドが保存されるとき、古い方を削除する
setopt inc_append_history      # 実行時に履歴をファイルにに追加していく
setopt auto_cd                 # ディレクトリ名だけで移動 (例: .. や ~/src と打つだけ)
setopt auto_pushd              # 移動履歴を残し cd -<Tab> で一覧から戻れる
setopt pushd_ignore_dups       # 移動履歴の重複を残さない

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

alias ls='ls -F'
alias la='ls -Fa'
alias ll='ls -Flh'
alias lla='ls -Falh'
alias ..='cd ../'
alias ...='cd ../../'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
# manをbatで読む (色+行番号)。bat不在時は通常表示。
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi
POWERLEVEL10K_HOME="${POWERLEVEL10K_HOME:-$HOME/powerlevel10k}"
[[ -f "${POWERLEVEL10K_HOME}/powerlevel10k.zsh-theme" ]] && source "${POWERLEVEL10K_HOME}/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
export PATH="$HOME/.d2/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

# Stage-2 live block (guarded): sheldon + fzf + zoxide + eza.
# zle-widget plugins stay silent without a terminal (piped zsh -i -c, dumb TERM).
if [[ -t 0 ]] && command -v sheldon >/dev/null 2>&1; then
  eval "$(sheldon source)"
fi
if [[ -t 0 ]] && command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
if [[ -t 0 ]] && [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi
if [[ -t 0 ]] && [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi
# fzf looks: fd source + mocha colors + right-side preview.
# Env vars only (no widgets), so safe without a terminal.
if command -v fzf >/dev/null 2>&1; then
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
  fi
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview '([[ -f {} ]] && bat --color=always --style=numbers --line-range=:100 {} 2>/dev/null) || ([[ -d {} ]] && eza -1 --color=always {} 2>/dev/null) || echo {}' --preview-window=right:55%:wrap --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi
# fzf-tab previews (needs fzf-tab from sheldon; harmless zstyle without it).
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '([[ -f $realpath ]] && bat --color=always --style=numbers --line-range=:80 $realpath 2>/dev/null) || eza -1 --color=always $realpath 2>/dev/null'
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi
if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -lh'
  alias la='eza -a'
fi

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"

[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1 && . "$(kiro --locate-shell-integration-path zsh)"
