#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="audiosettings"
rp_module_desc="Configure audio settings"
rp_module_section="config"
rp_module_flags="!x86 !mali"

function depends_audiosettings() {
    if [[ "$md_mode" == "install" ]]; then
        getDepends alsa-utils
    fi
}

function gui_audiosettings() {
    cmd=(dialog --backtitle "$__backtitle" --menu "Set audio output." 22 86 16)
    options=(
        1 "Auto"
        2 "Retro Nova internal Speaker"
        3 "HDMI"
        4 "Mixer - adjust output volume"
        R "Reset to default"
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choices" ]]; then
        case $choices in
            1)
                amixer cset numid=3 0
                alsactl store
                printMsgs "dialog" "Set audio output to auto"
                ;;
            2)
                #amixer cset numid=3 1
                #alsactl store
		sudo mv /etc/modprobe.d/alsa-base.conf.bak /etc/modprobe.d/alsa-base.conf
                printMsgs "dialog" "Set audio output to Retronova internal Speaker"
		sleep 2
                printMsgs "dialog" "Press A Button to reboot..."
                sleep 2
                sudo reboot
                ;;
            3)
                #amixer cset numid=3 2
                #alsactl store
		sudo mv /etc/modprobe.d/alsa-base.conf /etc/modprobe.d/alsa-base.conf.bak
                printMsgs "dialog" "Set Audio output to HDMI"
		sleep 2
		printMsgs "dialog" "Press A Button to reboot..."
		sleep 2
		sudo reboot
                ;;
            4)
                alsamixer >/dev/tty </dev/tty
                alsactl store
                ;;
            R)
                /etc/init.d/alsa-utils reset
                alsactl store
                printMsgs "dialog" "Audio settings reset to defaults"
                ;;
        esac
    fi
}
