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
echo "This script is executed at:: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR:: PLEASE RUN WITH ROOT USER $N" | tee -a $LOG_FILE
    exit 1
else
    echo -e "$G THIS SCRIPT IS RUNNING WITH ROOT USER $N" | tee -a $LOG_FILE
fi 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is:: $R FAILED $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is:: $G SUCCESS $N" | tee -a $LOG_FILE
    fi 
}

cp $SCRIPT_DIR/rabbitmq.sh /etc/yum.repos.d/rabbitmq.repo &>> $LOG_FILE
VALIDATE $? "copying rabbitmq"

dnf install rabbitmq-server -y &>> $LOG_FILE
VALIDATE $? "install rabbitmq"

systemctl enable rabbitmq-server &>> $LOG_FILE
systemctl start rabbitmq-server
VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
VALIDATE $? "add user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
VALIDATE $? "set permissions"

