#!/bin/bash

PREFIX=eden-app-frontend-poc
AWS_REGION=us-west-2

command -v aws >/dev/null 2>&1 || { echo >&2 "I require the aws cli but it's not installed.  Aborting."; exit 1; }

echo "Cuando el script se va ejecutando, la salida de cada comando sale en pantalla, presione 'q' para continuar..."
#se crea bucket para archivos
BUCKET_NAME="$PREFIX-files"
BUCKET_NAME_POLICY="$BUCKET_NAME-policy.json"

#replace place_holder con el nombre del bucket
cat frontend-bucket-policy.json | sed s/'{{BUCKET_NAME}}'/$BUCKET_NAME/g > $BUCKET_NAME_POLICY

aws s3api create-bucket --acl public-read \
                        --bucket $BUCKET_NAME \
                        --create-bucket-configuration LocationConstraint=$AWS_REGION

aws s3api put-bucket-policy  --bucket $BUCKET_NAME \
                             --policy file://$BUCKET_NAME_POLICY

#se crea bucket para turista
BUCKET_NAME="$PREFIX-turista"
BUCKET_NAME_POLICY="$BUCKET_NAME-policy.json"

#replace place_holder con el nombre del bucket
cat frontend-bucket-policy.json | sed s/'{{BUCKET_NAME}}'/$BUCKET_NAME/g > $BUCKET_NAME_POLICY

aws s3api create-bucket --acl public-read \
                        --bucket $BUCKET_NAME \
                        --create-bucket-configuration LocationConstraint=$AWS_REGION

aws s3api put-bucket-policy  --bucket $BUCKET_NAME \
                             --policy file://$BUCKET_NAME_POLICY

#se crea bucket para comercios
BUCKET_NAME="$PREFIX-comercios"
BUCKET_NAME_POLICY="$BUCKET_NAME-policy.json"

#replace place_holder con el nombre del bucket
cat frontend-bucket-policy.json | sed s/'{{BUCKET_NAME}}'/$BUCKET_NAME/g > $BUCKET_NAME_POLICY

aws s3api create-bucket --acl public-read \
                        --bucket $BUCKET_NAME \
                        --create-bucket-configuration LocationConstraint=$AWS_REGION

aws s3api put-bucket-policy  --bucket $BUCKET_NAME \
                             --policy file://$BUCKET_NAME_POLICY

