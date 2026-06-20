# One-shot bootstrap — runs once on first zsh login, then self-disables.
# Usage: drop this file as ~/.zshenv on a new machine (after installing zsh).
# It will fetch .zshrc, .zsh_plugins.txt, and .p10k.zsh from your dotfiles
# repo, install WakaTime, merge bash history, then leave a sentinel so it
# never runs again.
#
# NOTE: WakaTime API key is NOT included here — set it manually in ~/.wakatime.cfg
# after first login.

_BOOTSTRAP_SENTINEL="$HOME/.zshenv_bootstrapped"

if [[ ! -f "$_BOOTSTRAP_SENTINEL" ]]; then
  echo "=== Bootstrap: starting zsh setup ==="

  # 0. Check prerequisites
  echo ">>> Checking prerequisites..."
  _missing=()
  for _cmd in zsh git python3 wget; do
    if ! command -v "$_cmd" &>/dev/null; then
      _missing+=("$_cmd")
    fi
  done
  if [[ ${#_missing[@]} -gt 0 ]]; then
    echo "ERROR: Missing required packages: ${_missing[*]}"
    echo "       Please install them and try again:"
    echo "       sudo apt-get install -y ${_missing[*]}"
    return 1
  fi
  echo ">>> Prerequisites OK"

  # 1. Fetch dotfiles
  echo ">>> Fetching dotfiles..."
  _dotfiles_base="https://raw.githubusercontent.com/modem7/dotfiles/master"
  wget -q -O ~/.zshrc            "${_dotfiles_base}/.zshrc"
  wget -q -O ~/.zsh_plugins.txt  "${_dotfiles_base}/.zsh_plugins.txt"
  wget -q -O ~/.p10k.zsh         "${_dotfiles_base}/.p10k.zsh"

  # 2. Install WakaTime CLI
  echo ">>> Installing WakaTime..."
  python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"

  # 3. Enable WakaTime plugin in .zsh_plugins.txt (uncomment the sobolevn line)
  sed -i 's/^# sobolevn\/wakatime-zsh-plugin/sobolevn\/wakatime-zsh-plugin/' ~/.zsh_plugins.txt

  # 4. Merge bash history into zsh history
  echo ">>> Merging bash history..."
  if [[ -f ~/.bash_history ]]; then
    sort ~/.bash_history | uniq | awk '{print ": :0:;"$0}' >> ~/.zsh_history
  fi

  # 5. Mark bootstrap as complete
  touch "$_BOOTSTRAP_SENTINEL"
  echo "=== Bootstrap complete! ==="
  echo "    Remember to add your WakaTime API key to ~/.wakatime.cfg"
  echo "    Log off and back on (or run: exec zsh) to load your new config."
fi
