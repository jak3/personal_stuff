#!/bin/bash
str=`amixer -c 0 sget Master`
str1=${str#Simple*\[}
v1=${str1%%]*]}

echo $v1
