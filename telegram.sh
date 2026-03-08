#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin

THRESHOLD=65
# Modes available (intel is default): intel, amd
MODE='intel'
TELEGRAM_ENDPOINT='https://api.telegram.org/bot<token>/sendMessage'
CHAT_ID='<chat_id>'

if [ "$MODE" = 'amd' ]; then
        CPU_TEMP=$(sensors | grep Tctl | awk '{print $2}' | sed 's/[+]\([0-9]\+\)\..*/\1/' | sort -nr | head -n 1)
else
        CPU_TEMP=$(sensors | grep Core | awk '{print $3}' | sed 's/[+]\([0-9]\+\)\..*/\1/' | sort -nr | head -n 1)
fi

if  [ "$CPU_TEMP" -gt $THRESHOLD ];
 then
  curl --request 'POST' --url $TELEGRAM_ENDPOINT --header 'Content-Type: application/json' --data '{ "chat_id": '"$CHAT_ID"', "text": "WARNING: '"$HOSTNAME"': CPU temp is '"$CPU_TEMP"'°C"}'
fi
