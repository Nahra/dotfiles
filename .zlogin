# .zlogin is sourced in login shells.  It should contain commands that
# should be executed only in login shells.  It should be used to run a
# series of external commands (fortune, msgs, etc).

# Login shell ? If you want to know, you can type the following which will
# do nothing it's a login shell or warn you if not.
if [[ ! -o login ]]; then
    print "Warning: It is *not* a login-Shell\!"
fi


# reattachie screen lors d'une connexion en ssh (openSSH seuleument)
#if [ -n "$SSH_CONNECTION" ]; then
#    exec screen -AUDR
#fi


# startx at login when on /dev/console
startX.org () {
    if [ "$(tty)" = "/dev/tty1" ] ; then
#        aumute
#        sh -c 'screen -AUdmS SSH -c ~/.screenrcSSH'
#        sh -c 'screen -AUdmS SH -c ~/.screenrcSH'
#        fetchmail -k --fetchmailrc /home/Nahra/.fetchmailrc -d 300
#        dictd --config $HOME/public_html/dictd/dictd.conf −−pid−file $HOME/var/run/dictd.pid --log all --logfile $HOME/tmp/log/dictd
#        mpd
#        Nahra-editor
#        echo 30 > ~/.vol_saved
        ${HOME}/scripts/screen4Logs
        alsactl restore
        ${HOME}/scripts/aumute
        ${HOME}/scripts/run-mpd
        ${HOME}/scripts/emacsd start >/dev/pts/0 2>&1

#        ${HOME}/scripts/emacsd start >/dev/pts/0 2>&1

        sx >/dev/pts/0 2>&1
    fi
}
startX.org

# prints fortunes at login
nbsdtips () {
    for i in 1 2 3;
    do
        if [ "$(tty)" = "/dev/ttyE$i" ] ; then
            print "\n"
            /usr/games/fortune netbsd-tips
            print "\n"
        fi
    done
}
nbsdtips

#test for new files in mldonkey incoming
if [[ $(uname -n) = (tipheres|kahi) ]]
then
    if [[ -d ${MLDK_INCOMING} ]]
    then
        pushd ${MLDK_INCOMING}
        newfiles=( )
        [[ -a .timestamp ]] || sudo touch .timestamp
        setopt nullglob
        for file in ^.timestamp
            [[ $file -nt .timestamp ]] && newfiles=( $newfiles $file )
            if [[ -n $newfiles ]]
            then
                echo "New files in ${MLDK_INCOMING}:"
                print -l " "$newfiles
                echo ""
            fi
            sudo touch .timestamp
            popd
    fi
fi


# requis pour emacs
if [ "$TERM" = "dumb" ]
    then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi


setprompt () {
    # load some modules
    autoload -U colors zsh/terminfo # Used in the colour alias below
    colors
    setopt prompt_subst

    # Check the root UID
    if [[ $UID -eq 0 ]]; then # root
        eval UID_COLOR='$fg_bold[red]'
    else
        eval UID_COLOR='$fg_bold[blue]'
    fi

    PROMPT="%{$fg_bold[grey]%}[%{$fg_bold[green]%}%~%{$reset_color%}%{$fg_bold[grey]%}]%{$reset_color%}-%{$UID_COLOR%}>>%{$reset_color%} "
#;    RPROMPT="%{$fg_bold[green]%}%D{%H:%M}%{$reset_color%}"

    # The prompt used for spelling correction. The sequence `%R' expands to
    # the string which presumably needs spelling correction, and `%r' expands
    # to the proposed correction. All other prompt escapes are also allowed.
    SPROMPT=$'%BError!%b Correct %{\e[31m%}%R%{ \e[0m%}to%{ \e[36m%}%r%{ \e[0m%}? [No/Yes/Abort/Edit]: '
}
setprompt

# Check for TODO-entry
#if [[ -e ~/TODO ]] && [[ "$TERM" != "screen" ]]
#then
#    echo "Note: New TODO - entry!"
#    echo
#    cat ~/TODO
#    echo
#fi

#[ -x $(which gdircolors) ] && [ $HOME/.dir_colors ] && eval `gdircolors $HOME/.dir_colors -b`

# {{{ Autoload
autoload -U compinit
compinit

# URXVT workaround - stop first line completion bug in tiling WMs
#if test "$TERM" = "rxvt"; then
#    sleep 0.1 && clear
#fi


# utiliser cette section ou le .zlogin  : eval `gdircolors $HOME/.dir_colors -b`
# $ cd /usr/ports/misc/fileutils
# $ make install clean
#  di = directory
#  fi = file
#  ln = symbolic link
#  pi = fifo file
#  so = socket file
#  bd = block (buffered) special file (block device)
#  cd = character (unbuffered) special file (character device)
#  or = symbolic link pointing to a non-existent file (orphan)
#  mi = non-existent file pointed to by a symbolic link (visible when you type ls -l)
#  ex = file which is executable (ie. has 'x' set in permissions (executable)).
#
# 0   = default color                   1   = bold
# 4   = underlined                      5   = flashing text
# 7   = reverse field                   31  = red
# 32  = green                           33  = orange
# 34  = blue                            35  = purple
# 36  = cyan                            37  = grey
# 40  = black background                41  = red background
# 42  = green background                43  = orange background
# 44  = blue background                 45  = purple background
# 46  = cyan background                 47  = grey background
# 90  = dark grey                       91  = light red
# 92  = light green                     93  = yellow
# 94  = light blue                      95  = light purple
# 96  = turquoise                       100 = dark grey background
# 101 = light red background            102 = light green background
# 103 = yellow background               104 = light blue background
# 105 = light purple background         106 = turquoise background
#
# Attribute codes:
#  00 none
#  01 bold
#  02 faint                  22 normal
#  03 standout               23 no-standout
#  04 underline              24 no-underline
#  05 blink                  25 no-blink
#  07 reverse                27 no-reverse
#  08 conceal
#  
# export LS_COLORS="fi=36:di=32:ln=1;33:ec=\\e[0;37m:ex=1:mi=1;30:or=1;30:*.c=32:*.bz=32:*.txt=36;1:*.doc=37:*.zip=1;32:*.rar=1;32:*.lzh=1;32:*.lha=1;32:*.arj=1;32:*.tar=1;32:*.tgz=1;32:*.gz=1;32:*~=1;30:*.bak=1;30:*.jpg=1;35:*.gif=1;35:*.tif=1;35:*.tiff=1;35:*.mod=1;31:*.voc=1;31:*.smp=1;31:*.au=1;31:*.wav=1;31:*.s3m=1;31:*.xm=1;31:*.pl=1;33:*.c=1;33"
LS_COLORS=''
LS_COLORS=$LS_COLORS:'no=0'           # Normal text       = Default foreground  
LS_COLORS=$LS_COLORS:'fi=0'           # Regular file      = Default foreground
LS_COLORS=$LS_COLORS:'di=32'          # Directory         = Bold, Yellow
LS_COLORS=$LS_COLORS:'ln=01;36'       # Symbolic link     = Bold, Cyan
LS_COLORS=$LS_COLORS:'pi=33'          # Named pipe        = Yellow
LS_COLORS=$LS_COLORS:'so=01;35'       # Socket            = Bold, Magenta
LS_COLORS=$LS_COLORS:'do=01;35'       # DO                = Bold, Magenta
LS_COLORS=$LS_COLORS:'bd=01;37'       # Block device      = Bold, Grey
LS_COLORS=$LS_COLORS:'cd=01;37'       # Character device  = Bold, Grey
LS_COLORS=$LS_COLORS:'ex=35'          # Executable file   = Light, Blue
LS_COLORS=$LS_COLORS:'*FAQ=31;7'      # FAQs              = Foreground Red, Background Black
LS_COLORS=$LS_COLORS:'*README=31;7'   # READMEs           = Foreground Red, Background Black
LS_COLORS=$LS_COLORS:'*INSTALL=31;7'  # INSTALLs          = Foreground Red, Background Black
LS_COLORS=$LS_COLORS:'*.sh=47;31'     # Shell-Scripts     = Foreground White, Background Red
LS_COLORS=$LS_COLORS:'*.vim=35'       # Vim-"Scripts"     = Purple
LS_COLORS=$LS_COLORS:'*.torrent=4;33' # Torrents          = Orange, Underline
LS_COLORS=$LS_COLORS:'*.swp=00;44;37' # Swapfiles (Vim)   = Foreground Blue, Background White
LS_COLORS=$LS_COLORS:'*.sl=30;33'     # Slang-Scripts     = Yellow
LS_COLORS=$LS_COLORS:'*,v=5;34;93'    # Versioncontrols   = Bold, Yellow
LS_COLORS=$LS_COLORS:'or=01;05;31'    # Orphaned link     = Bold, Red, Flashing
LS_COLORS=$LS_COLORS:'*.c=1;33'       # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.C=1;33'       # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.h=1;33'       # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.cc=1;33'      # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.awk=1;33'     # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.pl=1;33'      # Sources           = Bold, Yellow
LS_COLORS=$LS_COLORS:'*.jpg=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.jpeg=1;32'    # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.JPG=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.gif=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.png=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.jpeg=1;32'    # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.ppm=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.pgm=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.pbm=1;32'     # Images            = Bold, Green
LS_COLORS=$LS_COLORS:'*.tar=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.tgz=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.gz=31'        # Archive           = Red
LS_COLORS=$LS_COLORS:'*.zip=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.sit=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.lha=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.lzh=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.arj=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.bz2=31'       # Archive           = Red
LS_COLORS=$LS_COLORS:'*.html=36'      # HTML              = Cyan
LS_COLORS=$LS_COLORS:'*.htm=1;34'     # HTML              = Bold, Blue
LS_COLORS=$LS_COLORS:'*.php=1;45'     # PHP               = White, Cyan
LS_COLORS=$LS_COLORS:'*.doc=1;34'     # MS-Word *lol*     = Bold, Blue
LS_COLORS=$LS_COLORS:'*.txt=1;34'     # Plain/Text        = Bold, Blue
LS_COLORS=$LS_COLORS:'*.o=1;36'       # Object-Files      = Bold, Cyan
LS_COLORS=$LS_COLORS:'*.a=1;36'       # Shared-libs       = Bold, Cyan
export LS_COLORS
