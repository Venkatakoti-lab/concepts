#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

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
    fi 
}

dnf module disable nodejs -y &>> $LOGS_FILE
VALIDATE $? "disable nodejs current version"

dnf module enable nodejs:20 -y &>> $LOGS_FILE
VALIDATE $? "enable nodejs:20 version"

dnf install nodejs -y &>> $LOGS_FILE
VALIDATE $? "Inastall nodejs

id roboshop
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
    VALIDATE $? "Add application user"
else
    echo -e "Already user existed:: $Y SKIPPING $N"
fi 

mkdir -p /app 
VALIDATE $? "Create App directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LOGS_FILE
VALIDATE $? "Download frontend code"

cd /app 
VALIDATE $? "change to app directory"

unzip /tmp/catalogue.zip &>> $LOGS_FILE
VALIDATE $? "Unzipping frontend code"

npm install &>> $LOGS_FILE
VALIDATE $? "Install dependencies

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying the catalogue service"

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
VALIDATE $? "Start catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo repo file"

dnf install mongodb-mongosh -y
VALIDATE $? "install mongodb"

mongosh --host mongodb.kanakam.online </app/db/master-data.js
