#!/bin/bash
aws sts get-caller-identity | jq ".Arn" | tr -d '"' | sed 's/user.*/root/g'
