# Execution timer
local last_exec_timer=0
local last_exec_timer_formatted=""

function format_exec_time() {
    local t="$1"
    local formatted_time
    
    local h=$((t/60/60/24))
    local m=$((t/60%60))
    local s=$((t%60))
    
    [[ $h > 0 ]] && formatted_time="$formatted_time ${h}h"
    [[ $m > 0 ]] && formatted_time="$formatted_time ${m}m"
    [[ $s > 0 ]] && formatted_time="$formatted_time ${s}s"

    echo "$formatted_time"
}

function preexec_update_exec_timer() {
    exec_timer="${exec_timer:-$SECONDS}"
}

function precmd_update_exec_timer() {
  if [ "$exec_timer" ]; then
    last_exec_timer=$(($SECONDS - $exec_timer))
    last_exec_timer_formatted=$(format_exec_time "$last_exec_timer")
    unset exec_timer
  else
    last_exec_timer=0
    last_exec_timer_formatted=""
  fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd precmd_update_exec_timer
add-zsh-hook preexec preexec_update_exec_timer

# Return status
local last_exec_ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})➜ %{$reset_color%}"

# Git prompt config
ZSH_THEME_GIT_PROMPT_PREFIX=":(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"

PROMPT='%{$fg[cyan]%}%~ %{$fg_bold[blue]%}$(git_super_status)%{$fg_bold[blue]%}% ${last_exec_ret_status}'
RPROMPT='$last_exec_timer_formatted [%*]'
