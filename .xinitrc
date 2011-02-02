#!/bin/zsh

# WM=${1:-twm}
# WM=${1:-stumpwm}
WM=${1:-xmonad}

# random-wallpaper &
# feh --bg-scale $HOME/IMGs/wallpapers/apple_bling-1920x1200.jpg &
feh --bg-scale $HOME/IMGs/wallpapers/1244132259591.com.cn.jpg &
#random-wallpaper-loop &

# xhost +local:Nahra@

if which dbus-launch >/dev/null && test -z "${DBUS_SESSION_BUS_ADDRESS}"; then
    eval `dbus-launch --sh-syntax --exit-with-session`
fi

urxvtd -q -f -o &

exec $WM & wmpid=$!
{
    run-dzen2 &

    # numlockx on

    setxkbmap -option terminate:ctrl_alt_bksp,grp:switch,grp:alt_shift_toggle,grp_led:scroll "us,fr(oss)"

    xset m 10/10 10 &
    xset -b -dpms s off r rate 140 25 &
    xset -r 144 -r 153 -r 160 -r 162 -r 164 -r 174 -r 176 -r 233 -r 234 &
    # xset +fp $HOME/.fonts &

    # tpb -d

    unclutter -idle 5 -jitter 10 -root &

    autocutsel -selection CLIPBOARD -fork &
    autocutsel -selection PRIMARY -fork &

    xautolock &

    [ -f $HOME/.Xresources ] && xrdb -load $HOME/.Xresources &
    [ -f $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap &
    # [ -f $HOME/.xbindkeysrc-$WM ] && xbindkeys -f $HOME/.xbindkeysrc-$WM &

    # xcompmgr &
    # xcompmgr -cC -o 1 &
    xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
    # xcompmgr -cC -t3 -r5 -o.65 -l-5 & # shadows
#    xcompmgr -cC -t-3 -l-5 -r5 -I0.02 -O0.03 -D4 -fF &
    # xcompmgr -cCfF -r7 -o 0.65 -l-10 -t-8 -D7 -I 0.020 -O 0.020 &
    # xcompmgr -cCfF -r7 -o.65 -l-10 -t-8 -D7 & # shadows and fades

    ${HOME}/scripts/screen4Logs &

    # firefox3 &
    # `echo $TERMCMD_1` -e opera -fullscreen &
    # `echo $TERMCMD_1` -name Terms1 &
    # `echo $TERMCMD_1` -name Terms1 &
    # `echo $TERMCMD_1` -name Terms1 &
    # `echo $TERMCMD_1` -name Terms2 &
    # `echo $TERMCMD_1` -name Terms2 &
    # `echo $TERMCMD_1` -name Terms2 &
    # `echo $TERMCMD_1` -name BKs -e sh -c 'cd $HOME/BOOKMARKS/CONVERT_UNIX/ALL ; zsh -l' &
    # `echo $sshfr` &
    # `echo $sshinfo` &
    # `echo $sshnet` &
    # `echo $sshorg` &
}
wait $wmpid
