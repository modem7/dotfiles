# dotfiles

[![Lint](https://github.com/modem7/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/modem7/dotfiles/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/modem7/dotfiles/blob/master/LICENSE)
[![Zsh](https://img.shields.io/badge/shell-zsh-89e051.svg)](https://www.zsh.org/)
[![antidote](https://img.shields.io/badge/plugins-antidote-blue.svg)](https://github.com/mattmc3/antidote)
[![Powerlevel10k](https://img.shields.io/badge/prompt-powerlevel10k-blueviolet.svg)](https://github.com/romkatv/powerlevel10k)

Personal zsh configuration for Debian/Ubuntu-based machines. Designed for platform engineering workflows — Docker, systemd, git, and SSH-heavy environments.

## Features

- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** prompt with instant prompt enabled
- **[antidote](https://github.com/mattmc3/antidote)** plugin manager in static mode — fast startup, no deprecation warnings
- **One-shot bootstrap** via `.zshenv` — drop it in `~` and `exec zsh` to set up a new machine
- **Per-machine overrides** via `~/.zshenv.local` — keeps machine-specific config out of the repo
- History tuned for multi-session use: 100k entries, file locking, cross-session sharing
- Sensible completion, syntax highlighting, and autosuggestions out of the box

## Files

| File | Purpose |
|---|---|
| `.zshenv` | One-shot bootstrap — fetches dotfiles, installs WakaTime, merges bash history |
| `.zshrc` | Main shell config — plugins, history, keybindings, aliases |
| `.zsh_plugins.txt` | antidote static plugin list |
| `.p10k.zsh` | Powerlevel10k prompt configuration |

## Bootstrap

On a fresh machine (zsh already installed):

```zsh
wget -q -O ~/.zshenv https://raw.githubusercontent.com/modem7/dotfiles/master/.zshenv
exec zsh
```

The bootstrap will:
1. Fetch `.zshrc`, `.zsh_plugins.txt`, and `.p10k.zsh` from this repo
2. Install the WakaTime CLI
3. Merge any existing bash history into zsh history
4. Leave a sentinel file (`~/.zshenv_bootstrapped`) so it never runs again

> **Note:** WakaTime API key is not included. Set it manually in `~/.wakatime.cfg` after first login.

## Per-machine configuration

Machine-specific settings go in `~/.zshenv.local` — this file is not committed to the repo and is sourced automatically if present.

Example — override the Docker Compose project directory on a different machine:

```zsh
# ~/.zshenv.local
export DC_PROJECT_DIR="/mnt/docker/myserver"
```

The default `DC_PROJECT_DIR` is `/mnt/docker/HDA`.

## Plugins

Managed via antidote static mode. The bundle is only regenerated when `.zsh_plugins.txt` is newer than the compiled bundle, keeping shell startup fast.

<!-- PLUGINS_START -->
| Plugin | Purpose |
|---|---|
| `romkatv/powerlevel10k` | Prompt theme with instant prompt support |
| `greymd/docker-zsh-completion` | Docker and Docker Compose CLI completion |
| `ohmyzsh/ohmyzsh path:plugins/ansible` | Ansible completion and aliases |
| `ohmyzsh/ohmyzsh path:plugins/command-not-found` | Suggests packages when a command is not found |
| `ohmyzsh/ohmyzsh path:plugins/extract` | Universal archive extraction — `x file.tar.gz` for any format |
| `ohmyzsh/ohmyzsh path:plugins/git` | Git aliases and completion |
| `ohmyzsh/ohmyzsh path:plugins/gitfast` | Faster git completion via optimised `_git` |
| `ohmyzsh/ohmyzsh path:plugins/history` | History search aliases (`h`, `hs`, `hsi`) |
| `ohmyzsh/ohmyzsh path:plugins/sudo` | Double-tap `Esc` to prepend sudo to the current command |
| `ohmyzsh/ohmyzsh path:plugins/systemd` | systemctl shorthand aliases (`sc-status`, `sc-restart`, etc.) |
| `ohmyzsh/ohmyzsh path:plugins/ubuntu` | apt/dpkg aliases for Ubuntu/Debian machines |
| ~~`sobolevn/wakatime-zsh-plugin`~~ *(disabled)* | WakaTime time tracking *(enabled by bootstrap, commented out by default)* |
| `MichaelAquilina/zsh-you-should-use` | Reminds you when an alias exists for a typed command |
| `belak/zsh-utils path:completion` | Additional completion utilities |
| `belak/zsh-utils path:utility` | General shell utility functions |
| `zsh-users/zsh-autosuggestions` | Fish-style inline command suggestions |
| `zsh-users/zsh-completions` | Extended completion definitions not yet in zsh |
| `zsh-users/zsh-syntax-highlighting` | Real-time command syntax highlighting |
<!-- PLUGINS_END -->

## Aliases

| Alias | Command |
|---|---|
| `zshconfig` | Open `.zshrc` in nano |
| `zshupdate` | Update all antidote plugins |
| `dcprune` | `docker system prune -af --volumes` |
| `dcup` *(commented)* | `docker compose up -d --remove-orphans` (uses `$DC_PROJECT_DIR`) |
| `dcdown` *(commented)* | `docker compose down` |
| `dcpull` *(commented)* | `docker compose pull` |
| `dive` | Run [dive](https://github.com/wagoodman/dive) via Docker |
| `bwu` *(commented)* | Unlock Bitwarden and sync |

## Requirements

- zsh
- git
- python3 (for WakaTime bootstrap)
- wget

Optional tools with graceful degradation if absent: `pipx`, `bw` (Bitwarden CLI).

## License

MIT
