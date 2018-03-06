#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

export NCURSES_NO_UTF8_ACS=1
## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

HEIGHT=14
WIDTH=38
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Manager Programs"

OPTIONS=(A "Couchpotato"
         B "Lidarr"
         C "Medusa"
         D "Mylar"
         E "Radarr"
         F "Sickrage"
         G "Sonarr"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      display=CouchPotato
      program=couchpotato
      port=5050
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags couchpotato 1>/dev/null 2>&1 ;;

    B)
      display=Lidarr
      program=lidarr
      port=8686
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lidarr 1>/dev/null 2>&1 ;;

    C)
      display=MEDUSA
      program=medusa
      port=8081
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa 1>/dev/null 2>&1 ;;

    D)
      display=Mylar
      program=mylar
      port=8090
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags mylar 1>/dev/null 2>&1 ;;

    E)
      display=Radarr
      program=radarr
      port=7878
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr 1>/dev/null 2>&1 ;;

    F)
      display=SickRage
      program=sickrage
      port=8082
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sickrage 1>/dev/null 2>&1 ;;

    G)
      display=Sonarr
      program=sonarr
      port=8989
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr 1>/dev/null 2>&1 ;;

    Z)
      exit 0 ;;
esac
    clear

########## Deploy Start
number=$((1 + RANDOM % 2000))
echo "$number" > /tmp/number_var

if [ "$skip" == "yes" ]; then
    clear
else

    HEIGHT=9
    WIDTH=42
    CHOICE_HEIGHT=5
    BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
    TITLE="Schedule a Backup of --$display --?"

    OPTIONS=(A "Weekly"
             B "Daily"
             Z "None")

    CHOICE=$(dialog --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    case $CHOICE in
            A)
                dialog --infobox "Establishing [Weekly] CronJob" 3 34
                echo "$program" > /tmp/program_var
                echo "weekly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy 1>/dev/null 2>&1
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            B)
                dialog --infobox "Establishing [Daily] CronJob" 3 34
                echo "$program" > /tmp/program_var
                echo "daily" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy 1>/dev/null 2>&1
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            Z)
                dialog --infobox "Removing CronJob (If Exists)" 3 34
                echo "$program" > /tmp/program_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nocron 1>/dev/null 2>&1
                --msgbox "\nNo Daily Backups will Occur of -- $display --!" 0 0
                clear ;;
    esac
fi
########## Deploy End

    dialog --title "$display - Address Info" \
    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/manager.sh
