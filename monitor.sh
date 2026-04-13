#!/bin/bash

BASE_DIR="$HOME/github/automated-linux-monitoring-system"
dir="$BASE_DIR/logs"

if [ ! -d "$dir" ]; then 
mkdir -p "$dir"
echo "The directory $dir has been created"
fi

TIMESTAMP=$(date +%Y%m%d_%H%M)
FILENAME="${TIMESTAMP}.log"
# Updated to use the variable
touch "$dir/${FILENAME}"

log_with_label() {

local label="$1"
shift
echo "============================'$label'=========================" >> "$dir/${FILENAME}"
eval "$@" | while IFS= read -r line; do
echo "[ $(date '+%Y-%m-%d %H %M %S') ] $line "
done >> "$dir/${FILENAME}"
}
disk_usage_alert(){
local usage="$1"
if [ "$usage" -gt 10 ]; then 
echo "Warning: The disk usage exceeds 10%" >> "$dir/${FILENAME}"
fi
}
log_with_label "Server date" "date"
log_with_label "Server uptime" "uptime"
log_with_label "Memeory usage" "free -h"
log_with_label "Disk uasge" "df -h /"
disk_usage_alert "$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')"
