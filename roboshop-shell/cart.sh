#!/bin/bash
R="\[31m"
G="\[32m"
Y="\[33m"
N="\[0m"

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD 

mkdir -p /var/log/shell-script
echo "This script is executed at:: $(date)" | tee -a $LOGS_FILE

if [ $USERID -ne 0 ]
then    
    echo -e "$R ERROR:: PLEASE RUN WITH ROOT USER $N" | tee -a $LOGS_FILE
    exit 1
else
    echo -e "$G YOU ARE RUNNING AS A ROOT USER $N" | tee -a $LOGS_FILE
fi 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is:: $R FAILED $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 is:: $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

dnf module disable nodejs -y &>> $LOGS_FILE
VALIDATE $? "dosable nodejs current version"

dnf module enable nodejs:20 -y &>> $LOGS_FILE
VALIDATE $? "enable nodejs:20"

dnf install nodejs -y &>> $LOGS_FILE
VALIDATE $? "install nodejs"

id roboshop
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
    VALIDATE $? "Create roboshop user"
else 
    echo -e "Already exist the user:: $Y SKIPPING $N"
fi 

mkdir -p /app 
VALIDATE $? "create app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>> $LOGS_FILE
VALIDATE $? "installing cart code"

cd /app 
unzip /tmp/cart.zip &>> $LOGS_FILE
VALIDATE $? "unzipping cart code"

npm install &>> $LOGS_FILE
VALIDATE $? "installing dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Copying the cart service"

systemctl daemon-reload
systemctl enable cart 
systemctl start cart
VALIDATE $? "start cart service"

