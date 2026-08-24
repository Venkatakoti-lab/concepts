#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FILE="$LOGSFOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p /var/log/shell-script
echo "This script is executed at:: $(date)"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: PLEASE RUN WITH ROOT USER $N" | tee -a $LOGS_FILE
    exit 1
else
    echo -e "$G THIS SCRIPT RUNS WITH ROOT USER $N" | tee -a $LOGS_FILE
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
VALIDATE $? "enable nodejs:20"

id roboshop
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE $? "create roboshop user"
else
    echo -e "already existing user:: $Y SKIPPING $N"
fi 

mkdir -p /app
VALIDATE $? "create app directory"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 
VALIDATE $? "download user code"

cd /app 
unzip /tmp/user.zip
VALIDATE $? "Unzipping the code"

npm install 
VALIDATE $? "install dependencies"

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "copying user service"

systemctl daemon-reload
systemctl enable user 
systemctl start user
VALIDATE $? "start user"

