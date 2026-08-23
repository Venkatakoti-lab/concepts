#!/bin/bash

USERID=$(id -u)

if [ $USERID -eq 0 ]
then
    echo "Your running this script as Root User"
else
    echo "ERROR:: Please run with root user"
    exit 1
fi


dnf list installed mysql

if [ $? -ne 0 ]
then
    dnf install mysql -y
    if [ $? -eq 0 ]
    then
        echo "MySql installation:: SUCCESS"
    else
        echo "MySql installation:: FAILURE"
        exit 1
    fi
else
    echo "MySql already installed:: Nothing to do"
fi 
