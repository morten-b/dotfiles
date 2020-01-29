HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
zstyle :compinstall filename '/home/morten/.zshrc'
export FZF_BASE=/home/morten/.fzf/bin/fzf
plugins=(
	fzf
)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
autoload -Uz compinit
compinit
