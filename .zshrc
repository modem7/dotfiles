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
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

# To update bundles, run the following:
# antigen update

# Apply changes
antigen apply

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

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Bitwarden completion
# eval "; compdef _bw bw;"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
