#!/bin/bash
aws sts get-caller-identity | jq ".Arn" | tr -d '"'
