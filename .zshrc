# Sources:
# https://insanet.eu/post/supercharge-your-terminal/

# Binaries:
# zoxide
# fzf
# eza

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -U PATH path
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Clone antidote if necessary.
[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# Source antidote.
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Initialize antidote's dynamic mode, which changes `antidote bundle`
# from static mode.
source <(antidote init)

# Set plugins (plugins not part of Oh-My-Zsh can be installed using githubusername/repo)
antidote bundle <<EOBUNDLES
  # Oh-My-Zsh
  ohmyzsh/ohmyzsh path:lib
  romkatv/powerlevel10k

  # Plugins
  greymd/docker-zsh-completion
  ohmyzsh/ohmyzsh path:plugins/command-not-found
  ohmyzsh/ohmyzsh path:plugins/extract
  ohmyzsh/ohmyzsh path:plugins/git
  ohmyzsh/ohmyzsh path:plugins/history
  ohmyzsh/ohmyzsh path:plugins/sudo
  ohmyzsh/ohmyzsh path:plugins/ubuntu
  ohmyzsh/ohmyzsh path:plugins/zoxide
  # sobolevn/wakatime-zsh-plugin
  belak/zsh-utils path:completion
  belak/zsh-utils path:prompt
  belak/zsh-utils path:utility
  Aloxaf/fzf-tab
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

## History command configuration
HISTSIZE=5000                 # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=5000                 # Number of history entries to save to disk

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # share command history data

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# exclude .. and . from completion
zstyle ':completion:*' special-dirs false
# show hidden files in completion
setopt glob_dots

export FZF_DEFAULT_COMMAND='rg --no-messages --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS="--no-separator --layout=reverse --inline-info"
# zoxide directory preview options
export _ZO_FZF_OPTS="--no-sort --keep-right --height=50% --info=inline --layout=reverse --exit-0 --select-1 --bind=ctrl-z:ignore --preview='\command eza --long --all {2..}' --preview-window=right"

# Aliases
alias zshconfig="nano ~/.zshrc"
alias zshupdate="antidote update"
alias fzfupdate="cd ~/.fzf && git pull && ./install --all"
# alias dcup="docker compose --project-directory /mnt/docker/VM/TdarrNode1 up -d --remove-orphans --timestamps"
# alias dcdown="docker compose --project-directory /mnt/docker/VM/TdarrNode1 down"
# alias dcpull="docker compose --project-directory /mnt/docker/VM/TdarrNode1 pull"
alias dcprune="docker system prune -af --volumes"
# alias gpull="(cd /home/modem7/Docker && git pull)"
# alias bwu='export BW_SESSION="" && bw sync -f'
alias ll='eza --long --all --group-directories-first -gh --git --git-repos --total-size'

# Bitwarden completion
# eval "$(bw completion --shell zsh); compdef _bw bw;"

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
# If you come from bash you might have to change your /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin.
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
        autoload -Uz add-zle-hook-widget
        function zle_application_mode_start { echoti smkx }
        function zle_application_mode_stop { echoti rmkx }
        add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
        add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# enable zsh completion
if [ "$(find ~/.zcompdump -mtime 1)" ] ; then
    compinit
fi
autoload -Uz compinit -C

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf autocompletion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh