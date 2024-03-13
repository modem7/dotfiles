if [ -e $HOME/.zshenv ]
then
    echo "Installing Wakatime"
    python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"
    sed -i "/sobolevn/ s/# *//" ~/.zshrc

    echo "Installing ZSH Dependencies"
    # zoxide
    echo "Installing zoxide"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    # fzf
    echo "Installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all

    # eza
    echo "Installing eza"
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update && sudo apt install -y eza
    
    echo "Merging Bash history with ZSH history"
    cd ~
    sort ~/.bash_history | uniq | awk '{print ": :0:;"$0}' >> ~/.zsh_history

    echo "Removing .zshenv file"
    rm $HOME/.zshenv
fi