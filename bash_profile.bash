#@IgnoreInspection BashAddShebang

#set -x

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Applications/Cocos/Cocos2d-x/cocos2d-x-3.10/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=/Applications/Cocos/Cocos2d-x
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Applications/Cocos/Cocos2d-x/cocos2d-x-3.10/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Araxis
export PATH=$PATH:/Applications/Araxis\ Merge.app/Contents/Utilities

export PATH="/usr/local/opt/redis@2.8/bin:$PATH"
eval "$(rbenv init -)"

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="%a $ "

# enable ctrl-s
stty -ixon

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
fi

export GIT_PROMPT_ONLY_IN_REPO=1
if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
    source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

function setMyPrompt() {
    # append history lines from this session to the history file
    history -a

    setGitPrompt

    local GPWD=$(git rev-parse --show-toplevel 2>/dev/null)
    local DEPOT=${GPWD##*/}
    local _PWD="${PWD/$GPWD/}"
    _PWD="${_PWD/$HOME/\~}"
    if [ -n "${DEPOT}" ]; then
        _PWD="${DEPOT} [${GIT_BRANCH}] ${_PWD}"
    fi
    case $TERM in
    xterm*)
        printf "\033]0;%s \007" "${_PWD}"
        ;;
    screen)
        printf "\033]0;%s \033\\" "${_PWD}"
        ;;
      esac

  iterm2_set_user_var gitBranch ${GIT_BRANCH}

  history -c
  history -a
}

export PROMPT_COMMAND="setMyPrompt"
