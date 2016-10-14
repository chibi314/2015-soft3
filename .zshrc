export LANG=ja_JP.UTF-8

eval "$(dircolors -b)"

autoload colors
colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# PROMPT
PROMPT="%{${fg[cyan]}%}[%~]%{${reset_color}%}
( ・8 ・) "
PROMPT2="%B%{${fg[yellow]}%}%_$%{${reset_color}%}%b "
#SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
SPROMPT="%B%{$fg[red]%}%{$suggest%}( ・8 ・)< もしかして%b %{${fg[green]}%}%r %B%{$fg[red]%}? [ちゅん!(y), ちゅん!(n),a,e]:${reset_color}%b "
# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
RPROMPT="%1(v|%F{green}%1v%f|)"
## 入力が右端まで来たらRPROMPTを消す
setopt transient_rprompt
setopt prompt_subst

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_no_store
setopt appendhistory		     # HISTFILEを上書きせずに追記
setopt hist_ignore_all_dups     # 重複したとき、古い履歴を削除
setopt hist_ignore_space	     # 先頭にスペースを入れると履歴を保存しない
setopt hist_reduce_blanks       # 余分なスペースを削除して履歴を保存
setopt share_history		     # 履歴を共有する
autoload history-search-end

# The following lines were added by compinstall

# コマンド補完の強化
if [ -d "$HOME/.zsh_setting/zsh-completions" ]; then
  fpath=(~/.zsh_setting/zsh-completions/src $fpath)
fi

# 補完
autoload -Uz compinit
compinit
## 補完候補を一覧表示
setopt auto_list
## TAB で順に補完候補を切り替える
setopt auto_menu
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=2
## 補完候補の色づけ
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## 補完候補を詰めて表示
setopt list_packed
## スペルチェック
setopt correct
## ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
## 大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr
## ビープを鳴らさない
setopt nobeep
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups
## =command を command のパス名に展開する
setopt equals
## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort
## 出力時8ビットを通す
setopt print_eight_bit
## ディレクトリ名だけで cd
setopt auto_cd
## {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
## コマンドラインでも # 以降をコメントと見なす
#setopt interactive_comments

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# デフォルトオプションの設定
export GREP_OPTIONS
# バイナリファイルにはマッチさせない
GREP_OPTIONS="--binary-files=without-match"
GREP_HELP=$(grep --help 2>&1)
# VCS管理用ディレクトリを無視する
if [[ "$GREP_HELP" == *--exclude-dir* ]]; then
	GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
	GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
	GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
	GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"
fi
# 可能なら色を付ける
if [[ "$GREP_HELP" == *--color* ]]; then
	GREP_OPTIONS="--color=auto $GREP_OPTIONS"
fi

if [ -f ~/.zsh_setting/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source ~/.zsh_setting/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

function chpwd() {
	ls --color=auto -C
}
function precmd() {
	psvar=()
	LANG=en_US.UTF-8 vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

function cdup-or-insert-circumflex() {
  if [[ -z "$BUFFER" ]]; then
    echo
    cd ..
    zle reset-prompt
  else
    zle self-insert '^'
  fi
}
zle -N cdup-or-insert-circumflex
bindkey '\^' cdup-or-insert-circumflex

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -dc $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
  esac
}

alias less='less -iM'

alias ls='ls --color=auto -G'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias more="less '-X -E -PM?f--More-- %f lines %lt-%lb/%L (%pb\%):--More-- lines %lt-%lb.'"

alias po='popd'

#alias -g L='| less'
#alias -g M='| more'
#alias -g H='| head'
#alias -g T='| tail'
#alias -g G='| grep'
#alias -g GI='| grep -i'
#alias -g LOG='| tee "log$(date +%Y%m%d%H%M).txt"'

alias -s {gz,tgz,zip,bz2,tbz,Z,tar,xz}=extract

alias vi='vim'
alias v='vim'
alias e='emacs'
alias g='git'
alias eg='eagle'
alias stmwrite="sudo stm32_writer -b bin/main.bin -d /dev/ttyUSB0 -l"
alias nau="nautilus ."
alias open='xdg-open'
alias op='open .'
alias rmsh='rm *.*#*'
alias ev='evince'
alias emacs='emacs24 -nw'
alias -g om='origin master'
alias keymap='~/.keybind.sh'
alias g++='g++ -std=c++11'
alias gccgl='gcc -lglut'
alias -g tegra-ubuntu="192.168.97.136"
alias -g saknee-pi="pi@192.168.97.145"

## Alias Commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --exclude-dir=.svn'


## SVN and SSH
export SSH_USER=anzai
export SVN_SSH="ssh -l ${SSH_USER}"

## ROS DISTRO
source $HOME/ros/indigo/devel/setup.zsh

## Rviz for a laptop user
export OGRE_RTT_MODE=Copy
source /opt/intel/bin/compilervars.sh intel64
