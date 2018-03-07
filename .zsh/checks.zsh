# checks (stolen from zshuery)
if [[ $(uname) = 'Linux' ]]; then
    IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
    IS_MAC=1
fi

if [[ -x `which brew 2> /dev/null` ]]; then
    HAS_BREW=1
fi

if [[ -x `which apt-get 2> /dev/null` ]]; then
    HAS_APT=1
fi

if [[ -x `which yum 2> /dev/null` ]]; then
    HAS_YUM=1
fi