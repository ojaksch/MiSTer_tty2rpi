20250829:
- Support for RPi5's dedicated UART connector
- Documentation added for UART serial on RPi5

20250820:
- Documentation added for GPIO serial on RPi5

20250716:
- Deprecation warning for SPI displays

20240329:
- Screensaver creates clock images only if enabled by SCREENSAVER_CLOCK (default "yes")
- Clock images are created in another temp directory and moved after creation
- Clock script starts screensaver mode regardless of whether clock is enabled or disabled
- Don't randomly cycle through images in screensaver, can be enabled with SCREENSAVER_RNDM (default "no"),
  with interval defined in SCREENSAVER_IVAL (default 10s)
- Silence the restart of screensaver service in journal

20240328:
- Clock optional with new parameter SCREENSAVER_CLOCK
- Better and faster search routine
- Screensaver with optional "also show Core and/or Game picture"

20240321:
- New parameter SHOWIPS to disable the IP addresses message at all

20240320:
- Silence some updater tasks

20240319:
- Beautify S60 script

20240318:
- Added gegenric ssh key for shutting down RPi from MiSTer

20240316:
- Option to receive core changes by serial - MiSTer part

20240315:
- Option to receive core changes by serial

20240314:
- Quiet removing obsolete splashscreen.service

20240311:
- doc: remove hint to -legacy- RPi OS

20240309:
- Fixed splash screen in bash_profile

20240307:
- Splash screen when shutdown or reboot

20240227:
- Add parameters to cmdline.txt.example for splash screen

20240227:
- Splash screen - see /etc/systemd/system/splashscreen.service for details
- tty2rpi logo now customizable

20240225:
- Search for filenames with at least three caracters, not two. This speeds up searching and lowers the risk of misinterpretation
- The INI variable KEEPASPECTRATIO is now undefined per default. The picture viewers feh/fim are now auto scaling a picture to screen's size. This speeds up displaying a picture a lot!  
Setting KEEPASPECTRATIO to yes/no/x/y re-enables pre-scaling.

20240222:
- Instructions for simple framebuffer devices in config.txt.example how to compile fbcp-ili9341
- New INI parameter: USEFBCP (whether to use fbcp-ili9341 or not, defaults to "no")
- New INI parameter: FBPIXFMT (Configurable Pixel Format for ffmpeg in tty2rpi-user.ini (RPi). Depends on framebuffer display - see https://ffmpeg.org/ffmpeg.html#Advanced-Video-options)

20240221: 
- Fixed wrong display dimension of SKU-MHS3528 in config.txt.example

20240214:
- For pure framebuffer devices we're using ffmpeg now instead of mplayer. This speeds up fps when playing a video including up/downscaling to the needed resolution and correct aspect ratio. mplayer is using only a single CPU core, ffmpeg is using "I'll take what I need and get"
- Better handling of default gateway in CMDSHOWIPS
- vlc: disable lua-scripts for faster startup

20240212:
- Some small internal rewrites
- For Video playback you can use mpv or mplayer as an alternative
- A new INI parameter is VIDEOPLAYER="vlc" which can be set to VIDEOPLAYER="mpv" (or mplayer) tty2rpi-user.ini (RPi).
VLC is great but looks like that it needs between 3 and 8 seconds before starts playing a video, mpv, however, up to 3 seconds only (running a RPi Zero 2W). That's why I'm taking this into account and hope that YOU will report your personal experience.
- Use file-caching instead of prefetch-buffer-size in INI for VLC

20240210:
- Removed obsolete files
- Updated documentation
- Removed prebuilt Raspberry Pi image
- Subfolder of a specific core is now correctly scanned
- You can now setup your own clock and "picture not available" by setting TTY2RPIPICS in tty2rpi-user.ini (RPi, see tty2rpi.ini for details)

20240207:
- Mention gpu_mem in config.txt.example
- No more need for wpa_supplicant.conf.example; cleanup of doc
- Changed .xinitrc; added .xinitrc-extra.example

20240130:
- Code rework, optimizations and support for loaded ROMs/Games

20240126:
- Code optimizations and fix for game with spaces in names

20240124:
- Display Waveshare 19173 confirmed working with Xorg
- added .xinitrc-extra
- modified config.txt.example

20240102:
- Debian Bookworm: Updated cmdline.txt.example

20231228:
- AutoLogin added

20231221:
- SPI/DPI/DSI Displays are now supported, as long as there exists a RPi DTO for it. See /boot/config.txt.example for examples

20231214:
- Support for GC9A01 displays

20230618:
- New system/user variable: VLCVIDEO - Defaults to mmal_vout. Change to xcb_x11 if MMAL is broken again)

20230603:
- Ensure that /tmp is writable after an update
- Use the zip file for Marquee pictures from MAME-EXTRAs as an alternative if it exist and not found otherwise
- Use p7zip-full instead of p7zip, the latter doesn't support zip archives
- Preparation to also use the zip file for pictures from MAME-EXTRAs
- p7zip added to RPi's installed packaged

20230527:
- Smaller font for IPs because of the length of public IPv6 addresses

20230428:
- Better handling of screensaver
- New INI option: KEEPASPECTRATIO

20230424:
- Fixed screensaver - missing conditional when set to no

20230326:
- inotify: reload user's systemd daemon after changing screensaver settings
- Don't save MAC as file

20230325:
- openbox/autostart: ensure unix linebreaks and also load tty2rpi-user.ini (RPi)
- Changes to the update service, Support for Batocera added

20230125:
- Starting support for Batocera

20230119:
- reduce timeout

20221215:
- Some optimations and new commands

20221102:
- opebox: also start update timer
- KILLPID: no quotes for kill command
- send feh of screensaver into background

20221031:
- Optimized CMDSHOWIP, fixed missing -source- commands

20221011:
- Fixed screensaver's exit
- Removed tty2rpi-user.ini (RPi) as it overwrites user's one, added MENUMODE
- Predefined and filled media folder marquee-pictures and marquee-videos
- systemd: auto update every friday 2pm + 2h per random
- Fixed execution of APTUPD

20221009:
- Rework of senddata
- Smarter autostart of openbox

20221007:
- Removed .bashrc
- Fixed typo in CMDCOR.sh/VIDEOARCADE, added mmal_vout to VLC

20221006:
- startup: wait for network

20221005:
- authorized_keys.example for paswordless ssh access

20221002:
- Search for media: stop after 1st find
- updater/rpi: update packages if missing
- Dropping prebuild image
- Added ffmpeg to apt
- CMDSHOWIPS: show hostname also
- Point to marquees.zip
- avahi optional
- Inform about the setup docs

20221001:
- pre-define user variables commented out in tty2rpi-user.ini (RPi)
- Setup-MiSTer: fixed wrong download path

20220925:
- rpi: example of commands changed
- rpi: list of commands
- rpi: tty2rpi-user.ini: COMMANDLINE
- rpi: flexible commands implemented
- rpi: rewrite of tty2rpi.sh
- rpi: tty2rpi-inotify.sh: MEDIA->COMMAND
- rpi: rewrite of openbox' autostart
- rpi: tty2rpi.ini: new function GETCMDLINE
- rpi setup: added bc to the list of packkages

20220917:
- Use ffmpeg instead of convert

20220916:
- Min filename length 3->2

20220915:
- Fixed finding files with spaces
- Fixed finding _alt* files

20220914:
- Fix setup by bash
- Fix path /tmp/home/tty2rpi/
- chmod +x ~/update_tty2rpi.sh
- ln -sf
- Silence rsync
- Added missing NODEBUG to update_tty2rpi.sh
- Added missing REPOSITORY_URL to update_tty2rpi.sh
- Added git to the needed tools
- move of the home files
- wget: fix path
- Updater and adjustments

20220912:
- mister: Optimations to S60
- autostart: run function KILLPID
- tty2rpi.ini (MiSTer): IPTIMEOUT
- Added rc.local to set bash instead of dash

20220911:
- RPi: include [stoNe font](https://www.dafont.com/font-comment.php?file=stone2) (100% Freeware)
- RPi: show IP addresses when starting

20220909:
- Organise into foolders

20220904:
- Fixed missing menu picture
- mister: S60: fixed hard coded socket

20220715:
- Initial commit, begin of a journey

