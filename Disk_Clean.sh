#!/bin/bash

# ==============================
# CONFIGURATION
# ==============================
LOG_FILE="/tmp/disk_cleanup.log"
DAYS=7
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "===== Disk Cleanup Started @ $DATE =====" >> $LOG_FILE

# ==============================
# CLEAN /tmp (older than X days)
# ==============================
echo "Cleaning /tmp older than $DAYS days..." >> $LOG_FILE
find /tmp -type f -mtime +$DAYS -exec rm -f {} \;

# ==============================
# CLEAN LOG FILES
# ==============================
echo "Cleaning logs older than $DAYS days..." >> $LOG_FILE
find /var/log -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;

# ==============================
# CLEAN OLD BACKUPS
# ==============================
BACKUP_DIR="/backup"

if [ -d "$BACKUP_DIR" ]; then
    echo "Cleaning backups older than $DAYS days..." >> $LOG_FILE
    find $BACKUP_DIR -type f -mtime +$DAYS -exec rm -f {} \;
fi

# ==============================
# CLEAR PACKAGE CACHE (Ubuntu)
# ==============================
if command -v apt-get >/dev/null 2>&1; then
    echo "Cleaning apt cache..." >> $LOG_FILE
    apt-get clean
fi

# ==============================
# CLEAR YUM CACHE (RHEL/CentOS)
# ==============================
if command -v yum >/dev/null 2>&1; then
    echo "Cleaning yum cache..." >> $LOG_FILE
    yum clean all
fi

# ==============================
# DISK USAGE AFTER CLEANUP
# ==============================
echo "Disk usage after cleanup:" >> $LOG_FILE
df -h >> $LOG_FILE

echo "===== Disk Cleanup Completed =====" >> $LOG_FILE