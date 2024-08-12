cd $HOME
echo "Work on " `pwd`

# oh-my-zsh
rm -rf $HOME/.oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache

isWSL=`uname -a | grep -i -e microsoft`
if [[ "$isWSL" != "" ]]; then
    mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/lib
    cp -fp $HOME/my-devel-config/misc.zsh.custom ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/lib/misc.zsh
    chmod +x ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/lib/misc.zsh
fi

# golang
if [ "`command -v go`" == "" ]; then
yum install -y golang
fi 

# fzf
rm -rf $HOME/.fzf
rm -f $HOME/.fzf.zsh
rm -f $HOME/.fzf.bash
#git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
#$HOME/.fzf/install

# fzf-vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c :PlugInstall -c :GoInstallBinaries -c :qa

ln -sfv ~/my-devel-config/zshrc ~/.oh-my-zsh/custom/ohmyzshrc.zsh 
mkdir -p ~/.oh-my-zsh/custom/themes
ln -sfv ~/my-devel-config/newro_vcs.zsh-theme ~/.oh-my-zsh/custom/themes/newro_vcs.zsh-theme
sed -i -E 's/robbyrussell/newro_vcs/g' ~/.zshrc
sleep 0.5
sed -i -E 's/^# DISABLE_UNTRACKED_FILES_DIRTY/DISABLE_UNTRACKED_FILES_DIRTY/g' ~/.zshrc
sleep 0.5
sed -i -E 's/^# HIST_STAMPS/HIST_STAMPS/g' ~/.zshrc
sleep 0.5
sed -i -E '54s/^/export _Z_NO_RESOLVE_SYMLINKS="1"\
/' ~/.zshrc
sleep 0.5
sed -i -E 's/plugins=(git/plugins=(evalcache git svn tmux fzf-tab zsh-completions zsh-syntax-highlighting history-substring-search z zsh-autosuggestions macos docker docker-compose/g' ~/.zshrc
echo "run on cmd[source $HOME/.zshrc]"
