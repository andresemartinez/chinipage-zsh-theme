# Execution timer
local last_exec_timer=0

function preexec_update_timer() {
    exec_timer=${exec_timer:-$SECONDS}
}

function precmd_update_timer() {
  if [ $exec_timer ]; then
    last_exec_timer=$(($SECONDS - $exec_timer))
    unset exec_timer
  fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd precmd_update_timer
add-zsh-hook preexec preexec_update_timer

# Return status
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)%{$reset_color%}"

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

PROMPT='%{$fg[cyan]%}%~ %{$fg_bold[blue]%}$(git_super_status)%{$fg_bold[blue]%}% ${ret_status}'
RPROMPT='${last_exec_timer}s [%*]'
