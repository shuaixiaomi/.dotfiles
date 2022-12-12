# mac
if [[ $UNAME_INFO =~ "Darwin" ]]; then
  # todo
  # intel
  # PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  
  # arm
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
  
  alias ls='ls -F --show-control-chars --color=auto'
  eval $(gdircolors -b $HOME/.dir_colors)
  export JAVA_HOME_8='/Users/lu5je0/Library/Java/JavaVirtualMachines/azul-1.8.0_352/Contents/Home'
  export JAVA_HOME_11='/Users/lu5je0/Library/Java/JavaVirtualMachines/temurin-11.0.17/Contents/Home'
  export JAVA_HOME_17='/Users/lu5je0/Library/Java/JavaVirtualMachines/temurin-17.0.5-2/Contents/Home'
  alias jdk8='export JAVA_HOME=$JAVA_HOME_8'
  alias jdk11='export JAVA_HOME=$JAVA_HOME_11'
  alias jdk17='export JAVA_HOME=$JAVA_HOME_17'
  alias e='open'
  alias sed='gsed'
  alias yy='pbcopy'
  alias p='pbpaste'
  alias iterm='open -a iTerm .'
  export JAVA_HOME=$JAVA_HOME_8
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"

  # brew
  export HOMEBREW_NO_AUTO_UPDATE=true

  # iterm title bar
  echo -en "\033]6;1;bg;red;brightness;44\a"
  echo -en "\033]6;1;bg;green;brightness;46\a"
  echo -en "\033]6;1;bg;blue;brightness;51\a"
elif [[ $UNAME_INFO =~ "microsoft" ]]; then
  function __git_prompt_git() {
    if [[ "$PWD" =~ '^/mnt/[cdefgh]/' ]]; then
      GIT_OPTIONAL_LOCKS=0 command git.exe "$@"
    else
      GIT_OPTIONAL_LOCKS=0 command git "$@"
    fi
  }
  export WSL_IP=$(hostname -I | awk '{print $1}')
  export WSL_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
  alias gst='__git_prompt_git status'
  alias gaa='__git_prompt_git add -A'
  alias gc='__git_prompt_git commit'
  alias gd='__git_prompt_git diff'
  alias grep='grep --color'
  alias e='explorer.exe'
  alias yy='win32yank.exe -i'
  alias p='win32yank.exe -o'
  alias cmd='/mnt/c/Windows/System32/cmd.exe /c'
  clippaste() {
    powershell.exe -noprofile -command Get-Clipboard | tr -d '\r'
  }
fi
