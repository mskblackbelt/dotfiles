# checks (stolen from zshuery)

if _command_exists brew; then
    HAS_BREW=1
fi

if _command_exists apt; then
    HAS_APT=1
fi

if _command_exists yum; then
    HAS_YUM=1
fi