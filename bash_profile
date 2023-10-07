
if [ "${EMERY_GNURC_BASH_PROFILE_LOADED:+already-loaded}" == 'already-loaded' ]
then
    return
fi
EMERY_GNURC_BASH_PROFILE_LOADED=true


#####
# Executed only once per login. Should include configurations that are not
# idempotent.
#####


###
# environment variables
###

PATH="${HOME}/.local/bin:${PATH}"
export HOSTNAME
export DISTRO_NAME="$(lsb_release --short --id)"
export DISTRO_VERSION="$(lsb_release --short --release)"
export HOSTNAME_LONG="${HOSTNAME}:${DISTRO_NAME}-${DISTRO_VERSION}"



###
# prompt
###

function resolve_ascii_color () {
    declare -r -A ascii_color_codes=(
        ['black']='\[\e[0;30m\]'
        ['red']='\[\e[0;31m\]'
        ['green']='\[\e[0;32m\]'
        ['brown']='\[\e[0;33m\]'
        ['blue']='\[\e[0;34m\]'
        ['purple']='\[\e[0;35m\]'
        ['cyan']='\[\e[0;36m\]'
        ['gray']='\[\e[0;37m\]'

        ['dark-grey']='\[\e[1;30m\]'
        ['bold-red']='\[\e[1;31m\]'
        ['bold-green']='\[\e[1;32m\]'
        ['bold-brown']='\[\e[1;33m\]'
        ['bold-blue']='\[\e[1;34m\]'
        ['bold-purple']='\[\e[1;35m\]'
        ['bold-cyan']='\[\e[1;36m\]'
        ['bold-white']='\[\e[1;37m\]'

        ['yellow']='\[\e[1;33m\]'
    )

    echo "${ascii_color_codes[$1]}"
}

USER_COLOR=$(resolve_ascii_color ${PROMPT_USER_COLOR:-red})
HOST_COLOR=$(resolve_ascii_color ${PROMPT_HOST_COLOR:-bold-white})
PATH_COLOR=$(resolve_ascii_color ${PROMPT_PATH_COLOR:-bold-blue})
TAIL_COLOR=$(resolve_ascii_color ${PROMPT_TAIL_COLOR:-bold-white})
RESET_COLOR='\[\e[0m\]'

PS1="[${USER_COLOR}\u${RESET_COLOR}@${HOST_COLOR}\h${RESET_COLOR} ${PATH_COLOR}\w${RESET_COLOR}]${TAIL_COLOR}$ ${RESET_COLOR}"

unset USER_COLOR HOST_COLOR PATH_COLOR TAIL_COLOR RESET_COLOR


###
# ssh
###

# Connect to ssh agent.
eval $(ssh-agent -s) > /dev/null

# Search for and add all identified keys.
for pubfile in $(find ${HOME}/.ssh -type f -name "*.pub")
do
    dir=$(dirname ${pubfile})
    stem=$(basename ${pubfile} ".pub")

    ssh-add ${dir}/${stem} 2> /dev/null
done


###
# APPLICATION: git
###

git config --global user.name "Emery Goss (${HOSTNAME_LONG})"
git config --global user.email "m.goss792@gmail.com"



if [ -r ${HOME}/.bashrc ]
then
    source ${HOME}/.bashrc
fi
