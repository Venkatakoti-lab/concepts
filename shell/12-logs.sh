#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

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

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $G $2 installation is:: SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$R $2 installation is:: FAILURE $N" | tee -a $LOG_FILE
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then 
    dnf install mysql -y &>> $LOG_FILE
    VALIDATE $? "MYSQL"
else
    echo -e "$Y MYSQL already installed:: SKIPPING $N" | tee -a $LOG_FILE
fi 

dnf list installed httpd 
if [ $? -ne 0 ]
then
    dnf install httpd -y &>> $LOG_FILE
    VALIDATE $? "HTTPD"
else
    echo -e "$Y HTTPD already installed:: SKIPPING $N" | tee -a $LOG_FILE
fi 

dnf list installed nginx 
if [ $? -ne 0 ]
then
    dnf install nginx -y &>> $LOG_FILE
    VALIDATE $? "NGINX"
else
    echo -e "$Y NGINX already installed:: SKIPPING $N" | tee -a $LOG_FILE
fi 