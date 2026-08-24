#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p /var/log/shell-script
echo "This script executed at:: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: PLEASE RUN WITH ROOT USER $N" | tee -a $LOG_FILE
    exit 1
else
    echo -e "$G YOU ARE RUNNING WITH ROOT USER $N" | tee -a $LOG_FILE
fi 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is:: $R FAILED $N"
        exit 1
    else
        echo -e "$2 is:: $G SUCCESS $N"
    fi 
}

dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "install mysql"

systemctl enable mysqld &>> $LOG_FILE
systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOG_FILE
VALIDATE $? "setup password"