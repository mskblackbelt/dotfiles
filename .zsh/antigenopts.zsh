source $ZDOTDIR/antigen.zsh

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
	battery 
	colored-man-pages 
	colorize 
	cp 
	extract 
	frontend-search
	git
	pip 
	python 
	pyenv
	thefuck
	virtualenv
EOBUNDLES

if [[ $IS_MAC -eq 1 ]]; then
	antigen bundle brew
	antigen bundle brew-cask
fi

if [[ $IS_LINUX -eq 1 ]]; then
	
fi

if [[ $HAS_APT -eq 1 ]]; then
	antigen bundle debian
fi

if [[ $HAS_YUM -eq 1 ]]; then
	antigen bundle dnf
	antigen bundle yum
fi

