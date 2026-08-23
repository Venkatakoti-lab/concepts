#!/bin/bash

USERID=$(id -u)

if [ $USERID -eq 0 ]
then
    echo "Your running this script as Root User"
else
    echo "ERROR:: Please run with root user"
    exit 1
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "$2 installation:: SUCCESS"
    else
        echo "$2 installation:: FAILURE"
        exit 1
    fi
}

dnf list installed mysql

if [ $? -ne 0 ]
then
    dnf install mysql -y
    VALIDATE $? "MYSQL"
else
    echo "MySql already installed:: Nothing to do"
fi 

dnf list installed httpd 

if [ $? -ne 0 ]
then
    dnf install httpd -y 
    VALIDATE $? "HTTPD"
else
    echo "HTTPD already installed:: Nothing to do"
fi
