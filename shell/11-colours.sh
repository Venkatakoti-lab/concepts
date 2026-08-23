#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR :: please run with root user $N"
    exit 1
else
    echo -e "$G You are now super user $N"
fi 

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 installation:: $G SUCCESS $N"
    else
        echo -e "$2 installation:: $R FAILURE $N"
        exit 1
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then
    dnf install mysql -y
    VALIDATE $? "MYSQL"
else 
    echo -e "$G MYSQL already installed.. NOTHING TODO $N"
fi