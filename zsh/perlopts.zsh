if [[ -x `which perl 2> /dev/null` ]]; then
  path=($path ~/perl5/bin(N))
  
  export PERL5LIB="${PERL5LIB}${PERL5LIB+:}/Users/mskblackbelt/perl5/lib/perl5"; 
  export PERL_LOCAL_LIB_ROOT="${PERL_LOCAL_LIB_ROOT}${PERL_LOCAL_LIB_ROOT+:}/Users/mskblackbelt/perl5";
  export PERL_MB_OPT="--install_base \"/Users/mskblackbelt/perl5\""; 
  export PERL_MM_OPT="INSTALL_BASE=/Users/mskblackbelt/perl5"; 
fi