#!/bin/zsh
#

# Zsh function
#
precmd () {
if [[ "$TERM" = "screen" || "$TERM" = "xterm-256color" ]]; then
local SHORTPWD="`basename $PWD`"
local HOMEDIR="`basename $HOME`"
if [[ "${SHORTPWD}" = "${HOMEDIR}" ]]; then
SHORTPWD="~"
fi
if [[ -n "$TMUX" ]]; then
tmux setenv TMUXPWD_$(tmux display -p "#I") $SHORTPWD
fi
echo -ne "\ek${SHORTPWD}/\e\\"
fi
}
preexec () {
if [[ "$TERM" = "screen" || "$TERM" = "xterm-256color" ]]; then
local CMD="${1}"
if [[ "${CMD}" = "vi" || "${${(z)CMD}[1]}" = "vi" ]]; then
CMD="VI:`basename $PWD`"
fi
if [[ ${#CMD} -ge 40 ]]; then
CMD="${${(z)CMD}[1]}${${(z)CMD}[2]}${${(z)CMD}[3]} _"
fi
echo -ne "\ek${CMD}\e\\"
fi
}

ignore_dir () {
# default value
local EXCLUDE_DIR="! -path \"*/.gopath~/*\" ! -path \"*/.git/*\" ! -path \"*/vendor/*\"" 

if [[ -f ~/.zsh.ignore ]]; then
    EXCLUDE_DIR=""
    for line in "${(@f)"$(<~/.zsh.ignore)"}"
    {
        EXCLUDE_DIR=${EXCLUDE_DIR}"! -path \"*/${line}/*\" "
    }
fi

echo "${EXCLUDE_DIR}"
}

_greps() {
    local line
    line=`set -o pipefail; rg --column --line-number --no-heading --color=always --sort path -g "$2" --smart-case "$1" | fzf --ansi` \
        && vim $(cut -d':' -f1 <<< "$line") +$(cut -d':' -f2 <<< "$line")
}

seds () {
if [[ "${3}" = "" ]]; then
    echo "se org dst file"
else
    eval "find . -type f -name \"${3}\" ${EXCLUDE_DIR} -exec sed -i -E 's/${1}/${2}/g' {} \;"
fi
}

mytail() {
if [[ "${1}" = "-F" ]]; then
    echo "tail ${1} ${2} | awk -f ~/my-devel-config/colorawk"
    tail ${1} ${2} | awk -f ~/my-devel-config/colorawk
else
    echo "tail -F ${1} | awk -f ~/my-devel-config/colorawk"
    tail -F ${1} | awk -f ~/my-devel-config/colorawk
fi
}

ps-left-toggle () {
    if [[ "${PS_LEFT}" = "detail" ]]; then
        export PS_LEFT="compact"
    else
        export PS_LEFT="detail"
    fi
}

ps-right-toggle () {
    if [[ "${PS_RIGHT}" = "detail" ]]; then
        export PS_RIGHT="compact"
    elif [[ "${PS_RIGHT}" = "compact" ]]; then
        export PS_RIGHT="noinfo"
    else
        export PS_RIGHT="detail"
    fi
}

cpuprofile() {
if [[ "${1}" = "" ]]; then
    echo "cpup <binary>"
else
    #go tool pprof -http=":8081" bin/burgundy http://localhost:6060/debug/pprof/profile
    go tool pprof -http=":8081" ${1} http://localhost:6060/debug/pprof/profile
fi
}

_calc() {
    echo "${1}" | bc
}

_ecurl() {
    if [[ "${1}" = "" ]]; then
        echo "ecurl <url>"
    else
        for i in {1..3}; do curl -s -w "lookup[%{time_namelookup}] connect[%{time_connect}] app_conn[%{time_appconnect}] pre_trans[%{time_pretransfer}] redirect[%{time_redirect}] start_trans[%{time_starttransfer}] total[%{time_total}]\n" -o /dev/null "${1}"; done
    fi
}

_cecurl() {
    if [[ "${1}" = "" ]]; then
        echo "cecurl <url>"
    else
        for i in {1..3}; do csrf=`grep csrftoken cookie.txt | awk '{print $7}'`; curl -b cookie.txt -H "X-CSRFToken: $csrf" -s -w "lookup[%{time_namelookup}] connect[%{time_connect}] app_conn[%{time_appconnect}] pre_trans[%{time_pretransfer}] redirect[%{time_redirect}] start_trans[%{time_starttransfer}] total[%{time_total}]\n" -o /dev/null $@; done
    fi
}

_stern () {
    if [[ "${2}" = "" ]]; then
        command stern -e healthCheck --template '{{color .PodColor .PodName}} {{.Message}}' $1
    else
        command stern -e healthCheck --template '{{color .PodColor .PodName}} {{.Message}}' -E $2 $1
    fi
}

_uuid() {
    uuidgen | tr '[:upper:]' '[:lower:]'
}

zle -N ps-left-toggle
zle -N ps-right-toggle

function prompt-length() {
  emulate -L zsh
  local COLUMNS=${2:-$COLUMNS}
  local -i x y=$#1 m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ));
    done
    local xy
    while (( y > x + 1 )); do
      m=$(( x + (y - x) / 2 ))
      typeset ${${(%):-$1%$m(l.x.y)}[-1]}=$m
    done
  fi
  echo $x
}

# Default rc loading
#
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

# Zsh environment
#
HISTSIZE=100000
SAVEHIST=10000
HISTFILE=~/.zsh/history
ZLE_RPROMPT_INDEN=0
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_no_store
setopt hist_no_functions
setopt no_hist_beep
setopt hist_save_no_dups
bindkey "^[[23~" 'ps-left-toggle' # Ctrl+F11
bindkey "^[[24~" 'ps-right-toggle' # Ctrl+F12


# Alias
#
alias gr='noglob _greps'
alias se='noglob seds'
alias vi="vim -T xterm-256color -u ~/.vimrc"
alias viclean='rm -rf ~/.vimtmpdir/.*;rm -rf ~/.vimtmpdir/*'
alias history='history -i -1000'
alias cpanplus='perl -MCPAN -eshell'
alias ctail='noglob mytail'
alias cscope="cd ~/xcat;ctags --sort=foldcase --regex-perl='/^[ \t]*method[ \t]+([^\ \t;\(]+)/\1/m,method,methods/' -R ~/xcat;cd -"
alias cpup='noglob cpuprofile'
alias calc='noglob _calc'
alias ecurl='noglob _ecurl'
alias cecurl='noglob _cecurl'
alias stern="noglob _stern"
alias uuid='noglob _uuid'
#alias kwatch="watch 'echo \"[\" `kubectl config current-context` \"]\";kubectl top po && kubectl get po'"

# Bind
#
if [ -d ~/.oh-my-zsh ]; then
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey "^[k" history-substring-search-up
bindkey "^[j" history-substring-search-down
bindkey "^[^M" autosuggest-accept
alias c=z
fi

# export
#
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:/lib:/usr/lib64:/usr/lib:/usr/local/lib64:/usr/local/lib:/usr/X11R6/lib64:/usr/X11R6/lib

export LEIN_ROOT=1
export ERLANG=/opt/erlang/bin
export HEROKU=/usr/local/heroku/bin
export GIT_SSL_NO_VERIFY=true
export TERM=xterm-256color
export PS_LEFT=compact # detail / compact
export PS_RIGHT=detail # detail / compact / noinfo

PATH=.:$PATH:/usr/local/bin:/bin:/usr/bin:$HOME:$ERLANG:$CLOJURE:$HEROKU
export PATH

source ~/my-devel-config/spectrum.zsh

if [[ "$PWD" =~ "^\/root$" || "$PWD" =~ "^$HOME$" ]]; then
    cd ~
fi

extraFiles=(
    ~/.dstask-zsh-completions.sh
    ~/.kubectl_fzf.plugin.zsh
    ~/my-devel-config/zshrc.fzf
    ~/my-devel-config/zshrc.jwt
    ~/my-devel-config/zshrc.wsl
    ~/my-devel-config/zshrc.pet
    ~/my-devel-config/zshrc.aws
    ~/my-devel-config/zshrc.direnv
    ~/my-devel-config/zshrc.authy
    ~/my-devel-config/zshrc.lvim
    ~/my-devel-config/zshrc.zoxide
    ~/.zshrc.local
)

for file in $extraFiles; do
    #echo "source $file"
    [ -f $file ] && source $file
done
