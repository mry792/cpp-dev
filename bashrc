
if [ "${EMERY_GNURC_BASHRC_LOADED:+already-loaded}" == 'already-loaded' ]
then
    return
fi
EMERY_GNURC_BASHRC_LOADED=true


#####
# Executed for every shell invocation. Should only include configurations that
# are idempotent.
#####


###
# filesystem options
###

# The pattern "**" used in a pathname expansion context will match all files and
# zero or more directories and subdirectories.
shopt -s globstar

# Set default new file/directory permission mask.
umask -S u=rwx,g=rx,o=rx > /dev/null


###
# history
###

# Append to the history file, don't overwrite it.
shopt -s histappend

# Multi-line commands are saved in history with embedded newline characters.
shopt -s lithist


###
# colors
###

# Enable color support of `ls`.
if [ -x /usr/bin/dircolors ]
then
    if [ -r ~/.dircolors ]
    then
        eval "$(dircolors --bourne-shell ~/.dircolors)"
    else
        eval "$(dircolors --bourne-shell)"
    fi
fi


###
# aliases and functions
###

# ls
alias  'l'='ls -lBh --color=always'
alias 'la'='l -a'

# "line count"
alias 'lc'='wc -l'

# Slightly narrow man window to allow for line numbers.
alias 'man'='MANWIDTH=$((${COLUMNS} - 6)) man'

# Color variants of some commands.
alias 'cgrep'='grep --color=always'
alias  'less'='less -R'

# Mercurial aliases.
# alias 'patches'='hg qseries -s'
# alias       's'='hg status -C'
# function glog () {
#   hg log $@ --graph --color always | less
# }
# function hd () {
#   hg diff $@ --color always | less
# }


# prompt
# PS1="[\[\033[0;31m\]\u\[\033[0m\]@\[\033[1;37m\]\h\[\033[0m\] \w]\[\033[1m\]$\[\033[0m\] "

# use 'less' as the pager for psql
export PAGER='less -SN'
