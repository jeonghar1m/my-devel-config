#!/bin/sh

if [ $# -eq 0 ]; then
DIR=`pwd`
if [ "$DIR" = *my-devel-config ]; then
    cd ..
    DIR=`pwd`
fi
else
DIR=$1
fi

export HOME=$DIR
cd $HOME
ID=`echo ${PWD##*/}`

cp -fp my-devel-config/myrc my-devel-config/myrc_local
cp -fp my-devel-config/gitconfig my-devel-config/gitconfig_local
sed -i -E "s|HOME_PASS_HERE|$DIR|g" my-devel-config/myrc_local
sed -i -E "s/ID_HERE/$ID/g" my-devel-config/myrc_local
echo "Hi~, do you config for git user's info"
echo "If you yes, you should set email/name for gitconfig."
echo "else, it will set email($ID@gmail.com) and name($ID) for git config."
while true; do
    read -p "input (y)es/(n)o >> " yn
    case $yn in
        [Yy]* ) 
            read -p "input email for git config >> " EMAIL;
            read -p "input name for git config >> " NAME;
            sed -i -E "s/EMAIL_HERE/$EMAIL/g" my-devel-config/gitconfig_local;
            sed -i -E "s/ID_HERE/$NAME/g" my-devel-config/gitconfig_local;
            break;;
        [Nn]* )
            sed -i -E "s/EMAIL_HERE/$ID@gmail.com/g" my-devel-config/gitconfig_local;
            sed -i -E "s/ID_HERE/$ID/g" my-devel-config/gitconfig_local;
            break;;
    esac
done

echo "디렉토리 생성..."
mkdir -p $HOME/.zsh
mkdir -p $HOME/.git_template/hooks

echo "심볼릭 릭크 생성..."
ln -sfv ~/my-devel-config/tmux.conf ~/.tmux.conf
ln -sfv ~/my-devel-config/screenrc ~/.screenrc
ln -sfv ~/my-devel-config/zshrc ~/.zshrc
ln -sfv ~/my-devel-config/vimrc ~/.vimrc
ln -sfv ~/my-devel-config/myrc_local ~/rundevel
ln -sfv ~/my-devel-config/gitconfig_local ~/.gitconfig
ln -sfv ~/my-devel-config/gitignore_global ~/.gitignore_global
ln -sfv ~/my-devel-config/dstask-zsh-completions.sh ~/.dstask-zsh-completions.sh

SUDO=""
if [ "$ID" != "root" ]; then
    SUDO=`which sudo`
fi

if [ ! -f /etc/zshrc ]; then
    $SUDO cp -fp ~/my-devel-config/etc_zshrc /etc/zshrc
fi

if [ -e ~/.vim ]; then
	echo "경고: 설치를 진행하려면 ~/.vim/ 디렉토리를 삭제해야 합니다."
	exit
fi

VI=`which vi`
echo "vim을 설치 합니다."

forMac=`uname -a | grep -ie darwin`
if [ ! -z "$forMac" ]; then
BREW=`which brew 2>&1`
if [ -z "$BREW" ]; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
fi

cronadd() {
    crontab -l 2>/dev/null | grep -Fq "$1" || echo "$1" | crontab -
}

brew install zsh
brew install tmux
brew install wget
brew install knqyf263/pet/pet
brew install bat
brew install coreutils
brew install dstask
brew install direnv
brew install oath-toolkit
brew install go-jira
brew install dive
brew install lazygit
brew install eza
git clone https://github.com/eza-community/eza.git ~/my-devel-config/eza
#brew install fig
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew install ffmpegthumbnailer unar jq poppler fd ripgrep fzf zoxide
brew install --HEAD yazi
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask raycast
brew install simnalamburt/x/jaso
mkdir -p ~/.jira.d
echo 'printf "endpoint: https://<SITENAME>.atlassian.net\nuser: <EMAILID>\npassword-source: keyring" > ~/.jira.d/config.yml'
echo 'alias ctags="`brew --prefix`/bin/ctags"' >> ~/.zshrc.local
cronadd "* * * * * /usr/local/bin/pet sync"
cronadd "* * * * * /usr/local/bin/dstask sync"
fi

forUbuntu=`uname -a | grep -i -e ubuntu -e microsoft`
if [ ! -z "$forUbuntu"]; then
yum install -y ncurses-devel
git clone https://github.com/vim/vim.git
cd vim
./configure --without-x --enable-cscope --enable-multibyte --enable-hangulinput --enable-pythoninterp=yes --enable-python3interp=yes
$SUDO make
$SUDO make install
VI="/usr/local/bin/vim"
ZSHELL=`which zsh 2>&1`
if [ "$ZSHELL" = "" ]; then
    $SUDO apt-get --assume-yes install zsh
fi
TMUXBIN=`which tmux 2>&1`
if [ "$TMUXBIN" = "" ]; then
    $SUDO apt-get --assume-yes install tmux
fi
$SUDO apt-get --assume-yes install fonts-powerline
fi
cd $HOME

export GIT_SSL_NO_VERIFY=true
echo "vundle 다운로드중..."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "vundle 설치중..."
$VI -c :BundleInstall -c :qa
