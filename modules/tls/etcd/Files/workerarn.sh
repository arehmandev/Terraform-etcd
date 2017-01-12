#!/bin/bash
aws iam get-role --role-name worker_role | jq ".Role.Arn" | tr -d '"'
