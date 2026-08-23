#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "nginx" "httpd")

mkdir -p /var/log/shell
echo "This script is executed at:: $(date) | tee -a $LOG_FILE

USERID=$(id -u)
if [ $? -ne 0 ]
then
    echo -e "$R ERROR:: please run with root user $N" | tee -a $LOG_FILE
    exit 1
else
    echo -e "$G you are running with root user $N" | tee -a $LOG_FILE
fi 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 :: FAILED $N" | tee -a $LOG_FILE
        exit 1 
    else
        echo -e "$G $2 :: SUCCESS $N" | tee -a $LOG_FILE
    fi
}

for package in ${PACKAGES[@]}
do
    dnf list installed $package
    if [ $? -ne 0 ]
    then
        echo -e "$R $package is not installed $N" | tee -a $LOG_FILE
        dnf install $package -y &>> $LOG_FILE
        VALIDATE $? "$package"
    else
        echo -e "$Y $package is already installed:: SKIPPING $N" | tee -a $LOG_FILE
    fi 
done