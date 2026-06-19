#!/bin/bash

LIVEUSER="live"

if [ "$USER" = "$LIVEUSER" ]; then
   sleep 2
   sudo -E calamares
else
    rm -rf ~/.config/autostart/start.desktop
fi

