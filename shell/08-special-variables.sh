#!/bin/bash

echo "ALL variables passed:: $@"
echo "no.of variables passed: $#"
echo "script name:: $0"
echo "hostname:: $HOSTNAME"
echo "current working directory:: $PWD"
echo "home directory of the user:: $HOME"
echo "PID of the current script:: $$"
sleep &10
echo "PID of the background script: $!"