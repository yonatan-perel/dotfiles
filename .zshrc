# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

plugins=(
	zsh-navigation-tools
	zsh-interactive-cd
	mygit
	myaws
	pfrepo
	temporal
	docker
	tunnels
	zsh-autosuggestions
	general
	tasks
	fzf-tab
)
source $ZSH/oh-my-zsh.sh
export XDG_CONFIG_HOME="$HOME/.config"

# Example aliases
alias vim="nvim"

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color yellow
prompt pure

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# For gh
export EDITOR=nvim

# pnpm
export PNPM_HOME="/Users/yonatan.perel/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# snowsql
alias snowsql='/Applications/SnowSQL.app/Contents/MacOS/snowsql'
# snowsql end

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
export PATH="$PATH:$HOME/go/bin"
export PATH="/Users/yonatan.perel/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
eval "$(~/.local/bin/mise activate zsh)"

# Mise activation start
eval "$(mise activate zsh)"
# Mise activation end

# Tmux auto session cd
source ~/.config/tmux/plugins/tmux-auto-session-cd/scripts/auto-session-cd.sh
