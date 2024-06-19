# HBS | rsar7sbootstrap
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is just simple linux bootstraping script from tar, forked from [s0me1newithhand7s](https://github.com/s0me1newithhand7s/hand7sbootstrap)

> [!CAUTION]
> • This script is ment to be executed from ```root``` user (sudo/doas) and if you **DO NOT** understand what exactly you doing - **DO NOT** execute it.  
> • I am do not responsable for actions perfomed by you.  
> • Make sure that you have `/dev/disk/by-label/root` and `/dev/disk/by-label/boot` as script is mounting them into `/mnt/hbs` directory!  

## :floppy_disk: Install
Just download script via curl and start it!  
Or, clone repo by `git clone https://github.com/Russanandres/rsar7sbootstrap.git`  
### Command-Line UI (hbs.sh)
```
curl https://raw.githubusercontent.com/Russanandres/rsar7sbootstrap/main/hbs.sh > /tmp/hbs.sh && sudo bash /tmp/hbs.sh
```
or
```
cd rsar7sbootstrap
chmod +x ./hbs.sh
./hbs.sh
```
### Terminal UI (gbs.sh)
```
curl https://raw.githubusercontent.com/Russanandres/rsar7sbootstrap/main/gbs.sh > /tmp/gbs.sh && sudo bash /tmp/gbs.sh
```
or
```
cd rsar7sbootstrap
chmod +x ./gbs.sh
./gbs.sh
```

## :flags: Run arguments
hbs.sh have a few little running arguments:
- `-v` OR `--version` - gives output about script version
- `-p` OR `--path` - change install path from /mnt/hbs to yours
- `-u` OR `--user` - Bypass check for root account and run from current
<!--- - `-a` OR `--arch` - change your archetecture from amd64 to other --->

  
## :information_source: Credentials & Thanks
Original script made by [s0me1newithhand7s](https://github.com/s0me1newithhand7s/hand7sbootstrap)  
Forked by [Russanandres](https://github.com/Russanandres)  
Testing by [MaxMur](https://github.com/themaxmur/) and [Russanandres](https://github.com/Russanandres)  
