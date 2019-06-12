#!/usr/bin/env bash

mountpoint=/Volumes/${host/.*/}

sudo mkdir ${mountpoint}
sudo sshfs -o allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa ${username}@${host}:/ ${mountpoint}
