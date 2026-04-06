#!/bin/bash
dir="logs"

if [ ! -d "$dir" ]; then 
mkdir "$dir"
echo "The directory "$dir" has been created"
fi
TIMESTAMP=$(date +%Y%m%d_%H%M)
FILENAME="${TIMESTAMP}.log"
touch "$HOME/github/automated-linux-monitoring-system/logs/${FILENAME}"

log_with_label() {

local label="$1"
local command="$2"
{
echo "==================='$label'=================="
if [ "$command" = "date" ]; then 
date | while IFS= read -r line; do
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line "
done

elif [ "$command" = "uptime" ]; then
uptime | while IFS= read -r line; do
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line "
done

elif [ "$command" = "df -h | head -1 && df -h | grep '/dev/sda2'" ]; then
(df -h | head -1 && df -h | grep '/dev/sda2') | while IFS= read -r line; do
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line "
done
usage=$(df -h | grep '/dev/sda2' | awk '{print $5}' | tr -d '%')
if [ "$usage" -gt 20 ]; then
echo "[$(date '+%Y-%m-%d %H:%M:%S')]  Warning: the disk usage exceeds 20%"
fi

elif [ "$command" = "free -h" ]; then
free -h | while IFS= read -r line; do
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line "

done
fi

} >> "$HOME/github/automated-linux-monitoring-system/logs/${FILENAME}" 
}
log_with_label "Server date" "date"
log_with_label "Server uptime" "uptime"
log_with_label "Disk uasge" "df -h | head -1 && df -h | grep '/dev/sda2'"
log_with_label "Memeory usage" "free -h"
