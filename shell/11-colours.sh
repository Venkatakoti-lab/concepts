#!/bin/bash
R=\e[31m
G=\e[32m
Y=\e[33m
N=\e[0m

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR $N:: please run with root user"
    exit 1
else
    echo "$G You are now super user $N"
fi 