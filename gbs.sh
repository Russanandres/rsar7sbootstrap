#!/usr/bin/env bash

# Add other archetectures support
# Add latest release ex.void, not hardcoded date
# Precoded options, such [Debian] in debain phase

# default settings
arc="amd64"
INSTPATH="/mnt/hbs"

while [ "$1" != "" ]; do
    case $1 in
        -v ) echo "release $VER"; exit;;

        -a | --arc )  arc=$2; shift;;
        -p | --path ) INSTPATH=$2;shift;;
        -u | --user ) noroot=1;;

        --version ) echo "Linux Bootstraper by Russanandres, forked from hand7s";exit;;
    esac;shift
done


checks() {
    if ! [ $(id -u) = 0 ] && [ -z $noroot ]; then
        echo -e "\033[1;34mRun me as a root.\033[0;37m"
        exit 1
    fi
    INSTPATH=$(readlink -f $INSTPATH)
    tempfile=`(tempfile) 2>/dev/null` || tempfile=/tmp/test$$
    trap "rm -f $tempfile" 0 $SIG_NONE $SIG_HUP $SIG_INT $SIG_QUIT $SIG_TERM;}


warning(){ trap "clear;exit" SIGINT
left=3
unit="seconds"
while test $left != 0;do
dialog --sleep 1 --title "RBS Warning!" "$@" --infobox "
Hello, this is warning message

You started program with root rights, what have access across the system.
We are NOT responsible for any damage caused to your system.
All responsibility lies solely with you!

You have $left $unit to read this..." 12 70
left=`expr $left - 1`
test "$left" = 1 && unit="second"
done;clear;}




dirmake() { mkdir -p $INSTPATH; cd $INSTPATH;}
input_error() { echo -e "\033[1;34mProvide a valid option!\033[0;37m";exit 1;}
dist_type(){ trap "clear;exit" SIGINT
dialog --clear --item-help --title "Choose something" --colors "$@" \
        --menu "Hi, this is a \Zumenu\Zn of all systems what we have.\n\n\
Please choose something one of that or cancel \n\
Install path is: \Zb$INSTPATH\Zn\n\
Choose it now!\n\n\
          Choose the OS you like:" 24 61 4 \
        "Arch"       "Linux, that you love to customize"            "Why not \Zbubuntu?" \
        "Debian"     "Golden standart of linux (my honest opinion)" "Or \ZbNetBSD?" \
        "Gentoo"     "System, that you compile yourself"            "Just say \"I Love waste time!\"" \
        "Slackware"  "Something old, but still updating"            "Perfect to learn linux story" \
        "Void"       "Just void linux)"                             "IDK what is that" \
        "."          ""                                             "Dummy for better UI and UX" \
        "Check"      "Dir files in chroots directory"               "dir C:\\mnt\\hbs" \
        "Remove"     "Just delete ALL chroots of $INSTPATH"         "Really ALL. We'll run rm -rf $INSTPATH/*" 2> $tempfile

retval=$?;DIST=$(cat $tempfile)
if [ $retval == 1 ]; then clear;exit; fi;}

dist_family() { trap "clear;exit" SIGINT
case $DIST in
Debian)
        dialog --clear --title "Select debian" "$@" \
        --menu "You can install 2 types of Debian!\n\n\
Ubuntu or real Debian?\n\
          Choose the OS you like:" 20 51 4 \
        "Debian"  "real Debian" \
        "Ubuntu"  "Modified debian for newbiers"  2> $tempfile
        DIST=$(cat $tempfile);;
Check ) { ls $INSTPATH/;sleep 5; } 2>&1 | dialog --progressbox "So, there are all of your chroots!" 30 100; dist_type;;
.)dist_type;;
Remove )
        dialog  --title "Remove all?" --clear "$@" \
        --yesno "Did you really want to delete ALL of chroots?\n\n\
It removes ALL files in directory $INSTPATH/*\n\
So, all files in there will be gone!\n\n\
                  Continue? " 10 50
    case $? in
    0 )  { rm -rfv $INSTPATH/*;sleep 3; } 2>&1 | dialog --progressbox "So, we are deleted all of your chroots!" 30 100; dist_type;;
    esac
;;
esac

left=3
unit="seconds"
while test $left != 0
do
dialog --sleep 1 \
	--title "HBS Warning" "$@" \
        --infobox "
You have been choosen $DIST!\n\n\n\n\n\n\n
Continue in $left $unit..." 10 40
left=`expr $left - 1`
test "$left" = 1 && unit="second"
done;clear;}



hbs_pacman() { trap "killall wget; rm archlinux-bootstrap-x86_64.tar.zst*;clear;exit" SIGINT
{ wget https://mirror.rackspace.com/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst && untar; } 2>&1 | dialog --progressbox "Now acquire arch tarball." 30 100; }


hbs_ubuntu(){ trap "killall wget; ubuntu-24.04-server-cloudimg-arm64-root.tar.xz*;clear;exit" SIGINT
{ wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-arm64-root.tar.xz && untar; } 2>&1 | dialog --progressbox "Now acquire ubuntu minimal tarball." 30 100; }


hbs_gentoo() {
dialog --clear --title "Void menu" "$@" --menu "You can install 2 types of gentoo3!\n\n\
Gentoo stage3 has 2 init managers:\n\n\
          Choose the init you like:" 20 51 4 \
        "Openrc"   "More light init, than systemd" \
        "Systemd"  "Overweight init lol"  2> $tempfile
GEN_INIT=$(cat $tempfile)

    if [ "$GEN_INIT" == "Openrc" ]; then
        trap "killall wget; rm stage3-$arc-openrc-20240428T163427Z.tar.xz*;clear;exit" SIGINT
        { wget https://distfiles.gentoo.org/releases/$arc/autobuilds/20240428T163427Z/stage3-$arc-openrc-20240428T163427Z.tar.xz && untar; } 2>&1 | dialog --progressbox "Now acquire gentoo openrc stage3 tarball." 30 100

    elif [ "$GEN_INIT" == "Systemd" ]; then
        trap "killall wget; rm stage3-$arc-systemd-20240428T163427Z.tar.xz*;clear;exit" SIGINT
        { wget https://distfiles.gentoo.org/releases/$arc/autobuilds/20240428T163427Z/stage3-$arc-systemd-20240428T163427Z.tar.xz && untar; } 2>&1 | dialog --progressbox "Now acquire gentoo systemd stage3 tarball." 30 100
    fi
}


hbs_slackware() { trap "killall wget; rm slackware64-current-mini-20160515.tar.xz*;clear;exit" SIGINT
{ wget https://ponce.cc/slackware/lxc/slackware64-current-mini-20160515.tar.xz && untar; } 2>&1 | dialog --progressbox "Now acquire slackware tarball." 30 100; }


hbs_void() {
dialog --clear --title "Void menu" "$@" --menu "You can install 2 types of void!\n\n\
Base void or void on musl?\n\n\
          Choose the OS you like:" 20 51 4 \
        "Base"  "One type of void linux" \
        "Musl"  "Second type of void, based on musl"  2> $tempfile
VOID_TYPE=$(cat $tempfile)
    if [ "$VOID_TYPE" == "Base" ]; then
        trap "killall wget; rm void-x86_64-ROOTFS-20240314.tar.xz*;clear;exit" SIGINT
        { wget https://repo-default.voidlinux.org/live/current/void-x86_64-ROOTFS-20240314.tar.xz && untar; } 2>&1 | dialog --progressbox "Now acquire void base tarball." 30 100

    elif [ "$VOID_TYPE" == "Musl" ]; then
        trap "killall wget; rm void-x86_64-musl-ROOTFS-20240314.tar.xz*;clear;exit" SIGINT
        { wget https://repo-default.voidlinux.org/live/current/void-x86_64-musl-ROOTFS-20240314.tar.xz && untar; } 2>&1 | dialog --progressbox "Now acquire void musl tarball." 30 100
    fi
}

hbs_deb_str() { {
    mkdir -p /usr/share/debootstrap/scripts/
    curl https://raw.githubusercontent.com/aburch/debootstrap/master/scripts/sid > /usr/share/debootstrap/scripts/sid
    curl https://raw.githubusercontent.com/aburch/debootstrap/master/functions > /usr/share/debootstrap/functions
    bash <(curl -fsLS https://raw.githubusercontent.com/aburch/debootstrap/master/debootstrap) --arch=$arc --make-tarball=debian.tar.gz --no-check-certificate --no-check-gpg sid /mnt/hsb http://deb.debian.org/debian/
    rm -rf /usr/share/debootstrap
    untar; } 2>&1 | dialog --progressbox "Well, here it is debian install:" 30 100
}

hbs_type() { clear
    case $DIST in
        Arch)       hbs_pacman;;
        Debian)     echo -e "\033[1;34mGood luck. Now you on your own. =)\033[0;37m";hbs_deb_str;;
        Ubuntu)     hbs_ubuntu;;
        Gentoo)     hbs_gentoo;;
        Slackware)  hbs_slackware;;
        Void)       hbs_void;;
    esac
}

untar() {
    echo -e "\n\nUncompressing tarball..."
    tar xpf *tar* --numeric-owner
    rm *tar*
}

checks
warning
dirmake
dist_type
dist_family
hbs_type

# Hello, Hand7s!
