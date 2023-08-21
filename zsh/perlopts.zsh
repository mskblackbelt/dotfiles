if _command_exists perl; then
  path=($path $HOME/perl5/bin(N))
  
  export PERL5LIB="${PERL5LIB}${PERL5LIB+:}$HOME/perl5/lib/perl5"; 
  export PERL_LOCAL_LIB_ROOT="${PERL_LOCAL_LIB_ROOT}${PERL_LOCAL_LIB_ROOT+:}$HOME/perl5";
  export PERL_MB_OPT="--install_base \"$HOME/perl5\""; 
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; 
fi