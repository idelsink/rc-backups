# no fuckups plz
alias   rm='rm -I'
alias   cp='cp -i'
alias   mv='mv -i'

# make all the things nice!
alias   ls='ls --color'
alias   ll='ls -lh --color'
alias   la='ll -a --color'
alias   less='less --raw-control-chars'

# let out my inner child!
alias   boop='touch'

# I did an oopsie
alias   fuck='sudo $(history -p \!\!)'

# some bash stuff
alias   reload-bashrc='. ~/.bashrc'
alias   dirs='dirs -v'

# ANSI color codes
BBLE="\033[44m"     # background blue
BBLK="\033[40m"     # background black
BCYN="\033[46m"     # background cyan
BGRN="\033[42m"     # background green
BMAG="\033[45m"     # background magenta
BRED="\033[41m"     # background red
BWHT="\033[47m"     # background white
BYEL="\033[43m"     # background yellow
DFLT="\033[39m"     # default
FBLE="\033[34m"     # foreground blue
FBLK="\033[30m"     # foreground black
FCYN="\033[36m"     # foreground cyan
FDGRY="\033[90m"    # foreground dark gray
FGRN="\033[32m"     # foreground green
FLGRN="\033[92m"    # foreground light green
FLGRY="\033[37m"    # foreground light gray
FMAG="\033[35m"     # foreground magenta
FRED="\033[31m"     # foreground red
FLRED="\033[91m"     # foreground light red
FWHT="\033[97m"     # foreground white
FYEL="\033[33m"     # foreground yellow
HC="\033[1m"        # hicolor
INV="\033[7m"       # inverse background and foreground
RS="\033[0m"        # reset
UL="\033[4m"        # underline

function git_color {
    local git_status="$(git status 2> /dev/null)"

    case "${git_status}" in
        *"Changes to be committed:"*)
            if [[ "${git_status}" =~ "Untracked files:" ]]; then
                echo -e "${FGRN}"; # some files staged
            else
                echo -e "${FLGRN}"; # all files stagged
            fi
            ;;
        *"Your branch is ahead of"*)
            echo -e "${FYEL}";
            ;;
        *"Changes not staged for commit:"*)
            echo -e "${FLRED}";
            ;;
        *"Untracked files:"*)
            echo -e "${FLGRY}";
            ;;
        *"nothing to commit, working directory clean"*)
            echo -e "${FLGRY}";
            ;;
        *)
            echo -e "${FDGRY}";
            ;;
    esac
}
function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"

    if [[ $git_status =~ $on_branch ]]; then
        local branch=${BASH_REMATCH[1]}
        echo "($branch)"
    elif [[ $git_status =~ $on_commit ]]; then
        local commit=${BASH_REMATCH[1]}
        echo "($commit)"
    fi
}

# PS1
# [user@host workdir-basename](git repo)$
# PS1="[\u@\h \W]"
# [workdir-basename]
PS1="[\W]"
PS1+="\[\$(git_color)\]"        # colors git status
PS1+="\$(git_branch)"           # prints current branch
PS1+="\[$RS\]"   # '#' for root, else '$'
PS1+="\$ "
export PS1

# include aliases with specific system aliases
if [ -f ~/.bash_aliases_system ]; then
        . ~/.bash_aliases_system
fi
