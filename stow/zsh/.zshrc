
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

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt share_history           # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_all_dups    # 同じコマンドをhistoryに残さない
setopt hist_ignore_space       # historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks      # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups       # 重複するコマンドが保存されるとき、古い方を削除する
setopt inc_append_history      # 実行時に履歴をファイルにに追加していく

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
POWERLEVEL10K_HOME="${POWERLEVEL10K_HOME:-$HOME/powerlevel10k}"
[[ -f "${POWERLEVEL10K_HOME}/powerlevel10k.zsh-theme" ]] && source "${POWERLEVEL10K_HOME}/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
export PATH="$HOME/.d2/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"

[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1 && . "$(kiro --locate-shell-integration-path zsh)"

# Stage-2 bridge (inert, T9): sheldon placeholder — NOT activated.
# Stage-2 plan: sheldon + fzf. Kept guarded + no-op so Stage-1 boot is unchanged.
if command -v sheldon >/dev/null 2>&1; then
  # eval "$(sheldon source)"  # Stage-2: uncomment to activate
  true
fi
