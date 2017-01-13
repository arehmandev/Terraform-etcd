#!/bin/bash


function getip {
for i in `aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $1 | grep -i instanceid  | awk '{ print $2}' | cut -d',' -f1| sed -e 's/"//g'`
do
aws ec2 describe-instances --instance-ids $i | grep -i PrivateIpAddress | awk '{ print $2 }' | head -1 | cut -d '"' -f2 |  xargs printf ',%s'
done;
}

getip $1 | sed  's/^,//' | sed -e 's/^[ \t]*//'
