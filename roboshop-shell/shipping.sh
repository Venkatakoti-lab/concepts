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
    echo -e "$G YOU ARE RUNNING WITH ROOT USER $N" | tee -a $LOG_FILE
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

dnf install maven -y &>> $LOG_FILE
VALIDATE $? "install maven"

id roboshop
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "create roboshop user"
else 
    echo -e "Already user existed :: $Y SKIPPING $N"
fi 

mkdir -p /app &>> $LOG_FILE
VALIDATE $? "create app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/ shipping-v3.zip &>> $LOG_FILE
VALIDATE $? "download shipping code"

cd /app &>> $LOG_FILE
unzip /tmp/shipping.zip &>> $LOG_FILE
VALIDATE $? "unzipping the ahipping code"

mvn clean package &>> $LOG_FILE
VALIDATE $? "clean package"

mv target/shipping-1.0.jar shipping.jar &>> $LOG_FILE
VALIDATE $? "moving shipping.jar"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service &>> $LOG_FILE
systemctl daemon-reload &>> $LOG_FILE
systemctl enable shipping &>> $LOG_FILE
systemctl start shipping 
VALIDATE $? "start shipping"

dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "install mysql"

mysql -h mysql.kanakam.online -uroot -pRoboShop@1 < /app/db/schema.sql &>> $LOG_FILE
VALIDATE $? "load schema"

mysql -h mysql.kanakam.online -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOG_FILE
VALIDATE $? "load app-user"

mysql -h mysql.kanakam.online -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOG_FILE
VALIDATE $? "load master data"

systemctl restart shipping
VALIDATE $? "restart shipping"

