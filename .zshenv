if [ -e $HOME/.zshenv ]
then
    echo "Installing Wakatime"
    python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"
    rm $HOME/.zshenv
fi