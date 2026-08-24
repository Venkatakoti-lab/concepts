#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p /var/log/shell-script
echo "This script is executed at:: $(date)" | tee -a $LOGS_FILE

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR:: PLEASE RUN WITH ROOT USER $N"
    exit 1
else
    echo -e "$G YOU ARE RUNNING WITH ROOT USER $N"
fi 
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is:: $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 is:: $G SUCCESS $N" | tee -a $LOGS_FILE
}

dnf module disable redis -y &>> $LOGS_FILE
VALIDATE $? "disable current redis version"

dnf module enable redis:7 -y &>> $LOGS_FILE
VALIDATE $? "enable redis:7 version"

dnf install redis -y &>> $LOGS_FILE
VALIDATE $? "install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no/' /etc/redis/redis.conf
VALIDATE $? "change configuration"

systemctl enable redis 
systemctl start redis 
VALIDATE $? "Start redis"