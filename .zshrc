for i in \
    zshoptions \
    zshcompctl \
    zshstyle \
    zshzle \
    zshfunctions \
    zshbindings \
    zshmisc
do
    if [ -f ${HOME}/.zshrc.d/${i} ]; then
        source ${HOME}/.zshrc.d/${i}
    else
        print "Note: ~/.zshrc.d/${i} is unavailable."
    fi
done

for i in \
    zshexports \
    zshaliases
do
    if [ -f ${HOME}/.zshrc.d/${i}/${i} ]; then
        source ${HOME}/.zshrc.d/${i}/${i}
    else
        print "Note: ~/.zshrc.d/${i}/${i} is unavailable."
    fi
done


# Test and then source the devel functions.
# painless is my "what-happend-when" - box (for debugging and so on)
#if [ ${HOSTNAME} = painless ] && [ -e ~/.zsh/zshdevel ]; then
#   source ~/.zsh/zshdevel
#fi
