#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

# echo "logs location is:: $LOG_FILE"

mkdir -p $LOGS_FOLDER
echo "script started executing at:: $(date)" | tee -a $LOG_FILE

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run with root user $N" | tee -a $LOG_FILE
    exit 1
else
    echo -e "$G You are now super user $N" | tee -a $LOG_FILE
fi 