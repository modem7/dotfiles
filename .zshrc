# Sources:
# https://insanet.eu/post/supercharge-your-terminal/

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -U PATH path
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Docker Compose project directory — override per-machine in ~/.zshenv.local
export DC_PROJECT_DIR="${DC_PROJECT_DIR:-/mnt/docker/HDA}"
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

# Clone antidote if necessary.
[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone --depth=1 --quiet https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# Set the path to the static plugins file and the generated bundle file.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
zsh_plugins_txt=${zsh_plugins}.txt
zsh_plugins_zsh=${zsh_plugins}.zsh

# Regenerate static bundle only when .zsh_plugins.txt is newer than the bundle.
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
if [[ ! "$zsh_plugins_zsh" -nt "$zsh_plugins_txt" ]]; then
  antidote bundle <"$zsh_plugins_txt" >"$zsh_plugins_zsh"
fi
source "$zsh_plugins_zsh"

## History command configuration
HISTSIZE=100000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=100000               # Number of history entries to save to disk

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when HISTFILE size exceeds HISTSIZE.
setopt HIST_FCNTL_LOCK        # Use file locking to prevent history corruption across sessions. # noka: ZC1979
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries anywhere in history.
setopt HIST_IGNORE_SPACE      # Ignore commands that start with space.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_VERIFY            # Show command with history expansion to user before running it.
setopt SHARE_HISTORY          # Share history across sessions (implies incremental append). # noka: ZC1928
unsetopt HIST_BEEP            # Don't beep when hitting the end of history.

# Shell behaviour
setopt AUTO_CD                # cd by typing a directory name without cd.
setopt CORRECT                # Suggest corrections for mistyped commands.

# Completion styling
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu select
# Exclude .. and . from completion
zstyle ':completion:*' special-dirs false
# Show hidden files in completion without glob_dots risk
zstyle ':completion:*' file-patterns '%p:globbed-files *(D):all-files'

# Completion initialisation — regenerate cache once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C # noka: ZC1686
fi

# pipx completions
if command -v pipx &>/dev/null; then
  autoload -U bashcompinit
  bashcompinit
  eval "$(register-python-argcomplete pipx)"
fi

# Syntax highlighting colours
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor root line)
ZSH_HIGHLIGHT_STYLES[cursor]='bg=#4e4e4e'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#4e4e4e"

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
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

# Setup key bindings accordingly
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
  zle_application_mode_start() { echoti smkx }
  zle_application_mode_stop() { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Aliases
alias zshconfig="nano ~/.zshrc"
alias zshupdate="antidote update"
alias dcprune="docker system prune -af --volumes"
# alias dcup="docker compose --project-directory ${DC_PROJECT_DIR} up -d --remove-orphans"
# alias dcdown="docker compose --project-directory ${DC_PROJECT_DIR} down"
# alias dcpull="docker compose --project-directory ${DC_PROJECT_DIR} pull"
# alias dive="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"
# alias bwu='export BW_SESSION="$(bw unlock --raw)" && bw sync -f'
# alias gpull="(cd /home/modem7/Docker && git pull)"

# Bitwarden shell completion
# if command -v bw &>/dev/null; then
#   eval "$(bw completion --shell zsh); compdef _bw bw;"
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
