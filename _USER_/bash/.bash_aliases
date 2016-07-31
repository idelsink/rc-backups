# no fuckups plz
alias   rm='rm -I'
alias   cp='cp -i'
alias   mv='mv -i'

# make all the things nice!
alias   ls='ls --color'
alias   ll='ls -lh --color'
alias   la='ll -a --color'

# I did an oopsie
alias   fuck='sudo $(history -p \!\!)'

# some bash stuff
alias   dirs='dirs -v'

# include aliases with specific system aliases
if [ -f ~/.bash_aliases_system ]; then
        . ~/.bash_aliases_system
fi
