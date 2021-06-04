#!/bin/bash

PREFIX=eden-app-frontend-poc
AWS_REGION=us-west-2

command -v aws >/dev/null 2>&1 || { echo >&2 "I require the aws cli but it's not installed.  Aborting."; exit 1; }

BUCKET_TURISTA="$PREFIX-turista"
aws s3api create-bucket --acl public-read \
                        --bucket BUCKET_TURISTA \
                        --region $AWS_REGION

#replace place_holder con el nombre del bucket

aws s3api put-bucket-policy  --bucket BUCKET_TURISTA \
                             --policy file://frontend-bucket-policy.json