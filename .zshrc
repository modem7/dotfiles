# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use antigen
source /usr/share/zsh-antigen/antigen.zsh

# Use Oh-My-Zsh
antigen use oh-my-zsh

# Set theme
antigen theme romkatv/powerlevel10k

# Set plugins (plugins not part of Oh-My-Zsh can be installed using githubusername/repo)
antigen bundles <<EOBUNDLES
  command-not-found
  git
  greymd/docker-zsh-completion
  history
  sobolevn/wakatime-zsh-plugin
  sudo
  ubuntu
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

# To update bundles, run the following:
# antigen update

# Apply changes
antigen apply

## History command configuration
HISTSIZE=5000                 # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=5000                 # Number of history entries to save to disk
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# If you come from bash you might have to change your /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin.
export PATH=/home/modem7//bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

# Auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

alias zshconfig="nano ~/.zshrc"
alias zshupdate="omz update && antigen update"
# alias dcup="docker compose --project-directory /mnt/docker/VM/TdarrNode1 up -d --remove-orphans --timestamps"
# alias dcdown="docker compose --project-directory /mnt/docker/VM/TdarrNode1 down"
# alias dcpull="docker compose --project-directory /mnt/docker/VM/TdarrNode1 pull"
alias dcprune="docker system prune -af --volumes"
# alias gpull="(cd /home/modem7/Docker && git pull)"
# alias bwu='export BW_SESSION="" && bw sync -f'

bindkey '\e[1~'   beginning-of-line  # Linux console
bindkey '\e[H'    beginning-of-line  # xterm
bindkey '\eOH'    beginning-of-line  # gnome-terminal
bindkey '\e[2~'   overwrite-mode     # Linux console, xterm, gnome-terminal
bindkey '\e[3~'   delete-char        # Linux console, xterm, gnome-terminal
bindkey '\e[4~'   end-of-line        # Linux console
bindkey '\e[F'    end-of-line        # xterm
bindkey '\eOF'    end-of-line        # gnome-terminal

# Bitwarden completion
# eval "; compdef _bw bw;"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
