#my-devel-config

tmux,screen / zsh / vim / git 환경 설정 프로젝트.

필요한 자원

- zsh
- tmux or screen
- vim 7.x
- git
- ripgrep
- pet

#설치하기

    mkdir <your ID>
    cd <your ID>
    git clone https://github.com/jeonghar1m/my-devel-config.git
    my-devel-config/install.sh
    ./rundevel
    my-devel-config/ohmyinstall.sh

#디렉토리 구조

| 이름             | 내용                                                                                  |
| ---------------- | ------------------------------------------------------------------------------------- |
| /plugins         | 커스텀 플러그인 <br/> vimrc에서 'source' 명령으로 이 디렉토리의 파일들을 incldue한다. |
| /dircolors       | dir color themes                                                                      |
| /docker          | docker ps & stats format                                                              |
| /hammerspoon     | (for mac) keyboard shortcut                                                           |
| README.md        | 지금 읽고 있는 파일                                                                   |
| install.sh       | 설치파일 <br/> 각 모듈 환경설정 파일을 생성한다.                                      |
| ohmyinstall.sh   | ohmyzsh+fzf 설치파일 <br/> 각 모듈 환경설정 파일을 생성한다.                          |
| tmux.conf        | ~/.tmux.conf -> ~/my-devel-config/tmux.conf                                           |
| screenrc         | ~/.screenrc -> ~/my-devel-config/screenrc                                             |
| zshrc            | ~/.zshrc -> ~/my-devel-config/zshrc                                                   |
| etc_zshrc        | /etc/zshrc -> ~/my-devel-config/etc_zshrc                                             |
| vimrc            | ~/.vimrc -> ~/my-devel-config/vimrc                                                   |
| gitconfig        | ~/.gitconfig -> ~/my-devel-config/gitconfig                                           |
| gitconfig_global | ~/.gitconfig_global -> ~/my-devel-config/gitconfig_global                             |
| myrc             | ~/rundevel -> ~/my-devel-config/myrc_local                                            |
|                  | myrc를 myrc_local로 복사한다                                                          |
| ~/.zshrc.local   | 자신만의 설정은 이 파일을 만들면 자동으로 읽어들임                                    |

# git alias 설명

| 이름 | 내용                                                    |
| ---- | ------------------------------------------------------- |
| ss   | git status without untracked (-u option with untracked) |
| lg   | graphical log history (-50 option will show more log)   |

# command 설명 : command snippet

| 이름                 | 내용                                                                                                       |
| -------------------- | ---------------------------------------------------------------------------------------------------------- |
| prev                 | command history를 보여주고, 선택한 command를 저장한다.                                                     |
| Ctrl + s             | pet에 저장된 command history를 검색한다.<br>검색 중 alt+c를 누르면 해당 cursor내용을 clipboard로 복사한다. |
| gr `keyword` `*.php` | 현재 디렉토리 하위의 모든 `*.php`파일에서 `keyword` 검색                                                   |

# oh-my-zsh + fzf 단축키 설명

| 이름                      | 내용                                                               |
| ------------------------- | ------------------------------------------------------------------ |
| Alt + f                   | File Search                                                        |
| Alt + d                   | Directory Search                                                   |
| Alt + r                   | Recent opened File Search                                          |
| c `keyword`               | Go to the most appropriate directory with keywords                 |
| `directory`               | Go to sub-directory without cd                                     |
| .. / ... / ....           | Go to parent directory with n-Depth                                |
| `keyword` + Up/Down Arrow | find command history with keyword                                  |
| Alt + Enter               | (in history mode) Move the cursor to the end to write this command |
| Alt + j/k                 | Up/Down for file selection                                         |

# Custom Vim 단축키 설명 (이 외엔 기본 Vim 단축키 이용)

| 이름              | 내용                                     |
| ----------------- | ---------------------------------------- |
| F4                | paste mode Toggle (입력모드에서 작동)    |
| F9                | Folder Navigator Toggle                  |
| F10               | Number line Toggle (입력모드에서도 작동) |
| F11               | Source Navigator Toggle                  |
| F12               | Tlist Toggle                             |
| :sp               | Horizon Split                            |
| :vs               | Vertical Split                           |
| Alt + hjkl        | Split 창간 상하좌우 이동                 |
| Alt + b           | Buffer list (Tab list), 닫기(q)          |
| ,z                | 좌측 탭 이동                             |
| ,x                | 우측 탭 이동                             |
| ,w                | 탭 닫기                                  |
| ,h                | Hex Mode View Toggle                     |
| Alt + f           | File Search                              |
| Alt + r           | Recent opened File Search                |
| Alt + s           | Current cursor word File Search          |
| + - / \* (keypad) | 현재 창의 크기 조절                      |

# Custom tmux 단축키 설명 (PREFIX : Ctrl + O)

| 이름        | 내용                                                           |
| ----------- | -------------------------------------------------------------- |
| PREFIX c    | New Pane                                                       |
| PREFIX x    | Pane Close                                                     |
| PREFIX h    | Horizon-Split Pane                                             |
| PREFIX v    | Horizon-Split Pane                                             |
| CTRL hjkl   | Move to Split Pane (Vi Style)                                  |
| PREFIX s    | Sync mode On (Split 된 모든 Pane에 동일 keyboard 입력)         |
| PREFIX S    | Sync mode Off                                                  |
| Alt + ,.    | Go to left/right Pane                                          |
| PREFIX num  | Go to numbered Pane (Alt + / : Go to previous Pane             |
| PREFIX z    | Zoom Pane Toggle                                               |
| PREFIX [    | Copy Mode (or 마우스 스크롤 업으로 Copy Mode 동작)             |
| PREFIX ]    | Paste                                                          |
| space or v  | Selection Mode (Shift + 마우스 드래그인 경우 Clipboard로 복사) |
| PREFIX m    | Mouse mode ON                                                  |
| PREFIX M    | Mouse mode OFF                                                 |
| Mouse Click | Pane/Window 선택 및 Pane Size 조정 가능                        |
| etc         | Screen 단축키와 거의 동일                                      |
