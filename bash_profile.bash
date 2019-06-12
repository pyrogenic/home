#@IgnoreInspection BashAddShebang

unset PROMPT_COMMAND

export PS4='+Line ${LINENO}: '

error() {
    echo "Error:"
    # get length of an array
    stackDepth=${#BASH_SOURCE[@]}
    # use for loop read all nameservers
    for (( i=0; i<10; i++ ));
    do
      echo "$i ----- ${FUNCNAME[$i]} ------ ${BASH_SOURCE[$i]}  ---- ${BASH_LINENO[$i]}"
    done
    for (( i=0; i<10; i++ ));
    do
      echo "$i ${FUNCNAME[$i]} at ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]}"
    done
}

# $BASH_LINENO = An array variable whose members are the line numbers in source files where each corresponding member of FUNCNAME was invoked.
# ${BASH_LINENO[$i]} is the line number in the source file (${BASH_SOURCE[$i+1]}) where ${FUNCNAME[$i]} was called
# (or ${BASH_LINENO[$i-1]} if referenced within another shell function).
# Use LINENO to obtain the current line number.
#trap error ERR

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

if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_THEME=Default\ NoExitState

    __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
    source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# TODO: PR for this fix
function we_are_on_repo() {
  if [[ -e "$(git rev-parse --git-dir 2> /dev/null)" ]]; then
    echo 1
  else
    echo 0
  fi
}

function setMyPrompt() {
    # append history lines from this session to the history file
    history -a

    # GPWD -- root of repo
    local GPWD=$(git rev-parse --show-toplevel 2>/dev/null)
    local DEPOT=${GPWD##*/}
    local _PWD="${PWD/$GPWD/}"
    _PWD="${_PWD/$HOME/\~}"
    if [[ -n "${DEPOT}" ]]; then
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

    if [[ $(we_are_on_repo) = 1 ]]; then
        local REPO_NAME=`basename ${GPWD}`
        iterm2_set_user_var gitBranch "${REPO_NAME} @ ${GIT_BRANCH}"
    else
        iterm2_set_user_var gitBranch ''
    fi
    history -c
    history -r
}

gp_install_prompt
export PROMPT_COMMAND="${PROMPT_COMMAND//;/\n};setMyPrompt"

echo "[$PROMPT_COMMAND]"

