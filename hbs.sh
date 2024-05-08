#!/usr/bin/env bash

# Add other archetectures support
# Add latest release ex.void, not hardcoded date
# Precoded options, such [Debian] in debain phase

# default settings
VER=1
arc=amd64
# Precoded user inputs:
DEB="debian"
DIST="debian"
GEN_INIT="openrc"
VOID_TYPE="musl"

echo $@
while [ "$1" != "" ]; do
    case $1 in
        -v ) echo $VER; exit;;

        -a | --arc ) arc=$2; shift;;

        --version ) echo "Linux Bootstraper $VER by Russanandres, forked from hand7s";exit;;
    esac;shift
done


checks() {
    if ! [ $(id -u) = 0 ]; then
        echo -e "\033[1;34mRun me as a root.\033[0;37m"
        exit 1
    fi;}

dirmake() { mkdir -p /mnt/hbs; cd /mnt/hbs;}
input_error() { echo -e "\033[1;34mProvide a valid option!\033[0;37m";exit 1;}
dist_type() { read -p "Family (arch/debian/gentoo/slackware/void) [debian]: " DIST;}

dist_family() {
    case $DIST in
    arch)       echo -e "\033[1;Choosen Arch.\033[0;37m";;
    debian)     read -p "Which type? (debian/ubuntu): [debian]" DEB;echo -e "\033[1;34mChoosen $DEB.\033[0;37m";;
    gentoo)     echo -e "\033[1;34mChoosen gentoo.\033[0;37m";;
    slackware)  echo -e "\033[1;34mChoosen slackware.\033[0;37m";;
    void)       echo -e "\033[1;34mChoosen Void.\033[0;37m";;
    *)          echo -e "\033[1;34mProvide one of the described option!\033[0;37m";dist_type;;
    esac
}

hbs_pacman() {
    echo -e "\033[1;34mNow acquire arch tarball.\033[0;37m"  
    wget https://mirror.rackspace.com/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst
    untar
}

hbs_deb() {
    if [ "$DEB" == "ubuntu" ]; then echo -e "\033[1;34mNow acquire ubuntu minimal tarball.\033[0;37m"
     wget https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-arm64-root.tar.xz;untar
    elif [ "$DEB" == "debian" ]; then echo -e "\033[1;34mGood luck. Now you on your own. =)\033[0;37m";hbs_deb_str
    else echo -e "\033[1;34mNo.\033[0;37m"; exit 1
    fi
}

hbs_gentoo() {
    read -p "Which gentoo stage3 we will use? (openrc/systemd) [openrc]: " GEN_INIT
    if [ "$GEN_INIT" == "openrc" ]; then
        echo -e "\033[1;34mNow acquire gentoo openrc stage3 tarball.\033[0;37m"  
        wget https://distfiles.gentoo.org/releases/$arc/autobuilds/20240428T163427Z/stage3-$arc-openrc-20240428T163427Z.tar.xz
    elif [ "$GEN_INIT" == "systemd" ]; then
        echo -e "\033[1;34mNow acquire gentoo openrc stage3 tarball.\033[0;37m"  
        wget https://distfiles.gentoo.org/releases/$arc/autobuilds/20240428T163427Z/stage3-$arc-systemd-20240428T163427Z.tar.xz
    else input_error
    fi;untar
}

hbs_slackware() {
    echo -e "\033[1;34mNow acquire slack tarball.\033[0;37m" 
    wget https://ponce.cc/slackware/lxc/slackware64-current-mini-20160515.tar.xz
    untar
}

hbs_void() {
    read -p "Wich type of void we will use? (base/musl) [musl]: " VOID_TYPE
    if [ "$VOID_TYPE" == "base" ]; then
        echo -e "\033[1;34mNow acquire void base tarball.\033[0;37m"  
        wget https://repo-default.voidlinux.org/live/current/void-x86_64-ROOTFS-20240314.tar.xz
    elif [ "$VOID_TYPE" == "musl" ]; then
        echo -e "\033[1;34mNow acquire void base tarball.\033[0;37m" 
        wget https://repo-default.voidlinux.org/live/current/void-x86_64-musl-ROOTFS-20240314.tar.xz
    else input_error
    fi;untar
}

hbs_deb_str() {
    if [ -d /usr/share ]; then
        mkdir /usr/share/debootstrap/
        mkdir /usr/share/debootstrap/scripts/
    else
        mkdir /usr/share/
        mkdir /usr/share/debootstrap/
        mkdir /usr/share/debootstrap/scripts/
    fi
    curl https://raw.githubusercontent.com/aburch/debootstrap/master/scripts/sid > /usr/share/debootstrap/scripts/sid
    curl https://raw.githubusercontent.com/aburch/debootstrap/master/functions > /usr/share/debootstrap/functions
    bash <(curl -fsLS https://raw.githubusercontent.com/aburch/debootstrap/master/debootstrap) --arch=$arc --make-tarball=debian.tar.gz --no-check-certificate --no-check-gpg sid /mnt/hsb http://deb.debian.org/debian/
    rm -rf /usr/share/debootstrap
    untar
}

hbs_type() {
    case $DIST in
        arch)hbs_pacman;;
        debian)hbs_deb;;
        gentoo)hbs_gentoo;;
        slackware)hbs_slackware;;
        void)hbs_void;;
    esac
}

untar() {
    echo -e "\033[1;34mUncompressing tarball.\033[0;37m"
    tar xpf *tar* --numeric-owner
    rm *tar* 
}

checks
dirmake
dist_type
dist_family
hbs_type

# Hello, Hand7s!
