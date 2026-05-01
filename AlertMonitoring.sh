#!/bin/bash

# ==============================
# CONFIGURATION
# ==============================
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/tmp/system_health.log"

DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "========== System Health Check @ $DATE ==========" >> $LOG_FILE

# ==============================
# CPU USAGE
# ==============================
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

CPU_INT=${CPU_USAGE%.*}

if [ $CPU_INT -gt $CPU_THRESHOLD ]; then
    echo "ALERT: High CPU Usage - $CPU_USAGE%" | tee -a $LOG_FILE
fi

# ==============================
# MEMORY USAGE
# ==============================
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
MEM_INT=${MEM_USAGE%.*}

if [ $MEM_INT -gt $MEM_THRESHOLD ]; then
    echo "ALERT: High percentage Memory Usage - $MEM_USAGE%" | tee -a $LOG_FILE
fi

# ==============================
# DISK USAGE
# ==============================
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "ALERT: High Disk Usage - $DISK_USAGE%" | tee -a $LOG_FILE
fi

# ==============================
# PROCESS CHECK
# ==============================
PROCESS_NAME="nginx"

if ! pgrep -x "$PROCESS_NAME" > /dev/null
then
    echo "ALERT: Process $PROCESS_NAME is NOT running!" | tee -a $LOG_FILE
fi

# ==============================
# PORT CHECK
# ==============================
PORT=80

if ! netstat -tuln | grep -q ":$PORT"
then
    echo "ALERT: Port $PORT is NOT listening!" | tee -a $LOG_FILE
fi

echo "==============================================" >> $LOG_FILE