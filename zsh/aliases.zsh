# Docker
function docker-compose-profile() {
  if [ -f docker-compose.yml ]; then
    docker compose --profile $1 up -d --build
  else
    echo "No docker-compose.yml found"
  fi
}
function docker-compose-logs(){
if [ -f docker-compose.yml ]; then
  docker compose logs -f $1 | pf_logs $2
else
  echo "No docker-compose.yml found"
fi
}

alias dcp="docker-compose-profile"
alias dcpd="docker-compose-profile discovery"
alias dcpp="docker-compose-profile platform"
alias dclf="docker-compose-logs"
alias dclfd="docker-compose-logs discovery-worker"

# General
function source_env() {
  set -a
  source .env
  set +a
}

alias e="exit"
alias s="pmset sleepnow"
alias senv="source_env"
eval "$(zoxide init zsh)"

# Git
function git_fuzzy_checkout {
	git checkout $(git branch -a | fzf)
}

function git_fuzzy_merge {
  git merge $(git branch -a | fzf)
}

function git_branch_checkout {
	git checkout $1
}

alias gfc="git_fuzzy_checkout"
alias gfm="git_fuzzy_merge"
alias gbc="git_branch_checkout"

# Temporal
function terminate_all_workflows {
    echo "Terminating all workflows"
    for workflow_id in $(temporal workflow list --namespace=pointfive --query "ExecutionStatus='Running'" --output json | jq '.[].execution.workflowId' -r); do
        echo "Terminating workflow $workflow_id"
        temporal workflow terminate --workflow-id $workflow_id --namespace pointfive
    done
}
alias twt="temporal workflow terminate --workflow-id --namespace pointfive"
alias twl="temporal workflow list --namespace pointfive"
alias twlr="temporal workflow list --namespace pointfive --query \"ExecutionStatus='Running'\""
alias twta="terminate_all_workflows"

# Tunnels
function tunnels() {
    pf_tunneler dev &
    pf_tunneler prod &
}
alias tunnles="tunnels"

# AWS
alias asl="aws sso login"
