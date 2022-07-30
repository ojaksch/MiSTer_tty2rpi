# Setting a the Raspberry Pi

In this HowTo I assume that you are already familiar with setting up a Raspberry Pi.

Obviously you need a Raspberry Pi. Any model except the Pico will do, but remember that - even a RPi1 will
do a fine job - the faster the RPi is, the more responsive your experience will be.
From my personal experience a good minimum is the RPi2, better would be a RPi3. A good choice regarding
price/power a RPi 3A+

Download the **Raspberry Pi OS Lite** of your choice from https://www.raspberrypi.com/software/operating-systems/
The usual version is the 32-bit version of the RPi OS for *all* RPi board releases, but if you would like to go
the 64-bit way and you are using a RPi 3A+ or greater, grab the 64-bit RPi OS.

Setup a SD card with the downloaded image. Insert the SD into your RPi, connect all needed cables and devices
and boot up your RPi. Follow the instruction there and setup your user and password. Enable and setup WiFi if you want to use it.

Update your Raspberry Pi OS and install the following packages (**needs to be reviewed**):

```sudo apt install mc inotify-tools netcat-openbsd flex bison readline-common ncurses-base libreadline-dev libgif-dev \
 libtiff-dev libjpeg62-turbo-dev libexif-dev xorg xserver-xorg-video-fbdev openbox libsdl-image1.2-dev imagemagick vlc feh```

Disable avahi:
```sudo systemctl disable avahi-daemon.service avahi-daemon.socket```
