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
alias gl="lazygit"
alias gcon="git commit --no-verify"
alias prv="gh pr view --web"
alias gmm="git pull origin master"

# AWS
alias asl="aws sso login"
