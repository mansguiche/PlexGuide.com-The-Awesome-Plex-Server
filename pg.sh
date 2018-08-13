#!/bin/bash
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

######################################################## START: Key Variables
# Generate Default YML
bash /opt/plexguide/roles/install/scripts/yml-gen.sh
# Ensure Default Folder Is Created
mkdir -p /var/plexguide
# PG Version
echo "6.031" > /var/plexguide/pg.version
# Force Common Things To Execute Such as Folders
echo "136" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "5" > /var/plexguide/pg.ansible
echo "2" > /var/plexguide/pg.rclone
echo "2" > /var/plexguide/pg.python
echo "1" > /var/plexguide/pg.docker
echo "1" > /var/plexguide/pg.id
echo "1" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.motd
echo "31" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep

# Declare Variables Vital for Operations
bash /opt/plexguide/roles/install/scripts/declare.sh
######################################################## END: Key Variables
#
#
######################################################## START: Start
bash /opt/plexguide/roles/install/scripts/start.sh
### Users Agreement Handling
file="/var/plexguide/update.failed"
if [ -e "$file" ]
  then
  exit
  #### Put Execute PG Command Here
fi
######################################################## END: Start
#
#
######################################################## START: Ansible
bash /opt/plexguide/roles/install/scripts/ansible.sh ### Good
######################################################## END: Ansible
#
#
######################################################## START: Alias
bash /opt/plexguide/roles/install/scripts/alias.sh ### Good
######################################################## END: Alias
#
#
######################################################## START: Server ID
bash /opt/plexguide/roles/install/scripts/id.sh ### Good
######################################################## END: Server ID
#
#
######################################################## START: Folders
bash /opt/plexguide/roles/install/scripts/folders.sh ### Good
######################################################## END: Folders
#
#
######################################################## START: Docker
bash /opt/plexguide/roles/install/scripts/docker.sh ### Test Docker
######################################################## END: Docker
#
#
######################################################## START: DocStart
bash /opt/plexguide/roles/install/scripts/docstart.sh ### Good
######################################################## END: DocStart
#
#
######################################################## START: MOTD
bash /opt/plexguide/roles/install/scripts/motd.sh
######################################################## END: MOTD
#
#
######################################################## START: Python
bash /opt/plexguide/roles/install/scripts/python.sh &>/dev/null & ### Maybe Good?
######################################################## END: Python
#
#
######################################################## START: Common Functions
# Ensure the PG Common Functions Are Aligned
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored
######################################################## END: Common Functions