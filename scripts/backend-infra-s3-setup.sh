#!/bin/bash
STACK=prod #stage
PREFIX="eden-app-frontend-$STACK"
AWS_REGION=us-east-2

command -v aws >/dev/null 2>&1 || { echo >&2 "I require the aws cli but it's not installed.  Aborting."; exit 1; }

# utils
create_public_bucket(){
    # $1: bucket name
   
    BUCKET_NAME="$1"
    local BUCKET_NAME_POLICY="$BUCKET_NAME-policy.json"

     #replace place_holder con el nombre del bucket
    cat frontend-bucket-policy.json | sed s/'{{BUCKET_NAME}}'/$BUCKET_NAME/g > $BUCKET_NAME_POLICY

    aws s3api create-bucket --acl public-read \
                            --bucket $BUCKET_NAME \
                            --create-bucket-configuration LocationConstraint=$AWS_REGION

    aws s3api put-bucket-policy  --bucket $BUCKET_NAME \
                                 --policy file://$BUCKET_NAME_POLICY
}

create_cloudfront_distribution() {
    # https://jmespath.readthedocs.io/en/latest/specification.html#ends-with
    BUCKET_NAME="$1"
    REFERENCE="$BUCKET_NAME-ref"
    DOMAIN_NAME="$BUCKET_NAME.s3.amazonaws.com"
    BUCKET_NAME_DIST="$BUCKET_NAME-dist.json"

    cat dist-config.json | sed s/'{{REFERENCE}}'/$REFERENCE/g | sed s/'{{DOMAIN_NAME}}'/$DOMAIN_NAME/g > $BUCKET_NAME_DIST

    aws cloudfront create-distribution \
                    --distribution-config file://$BUCKET_NAME_DIST
}

create_website(){
    BUCKET_NAME="$1"
    create_public_bucket "$BUCKET_NAME"
    aws s3 website "s3://$BUCKET_NAME" --index-document index.html --error-document index.html
    create_cloudfront_distribution "$BUCKET_NAME"
}

create_website_for(){
    BUCKET_NAME="$PREFIX-$1"
    create_website "$BUCKET_NAME"
}

create_public_bucket_for(){
    BUCKET_NAME="$PREFIX-$1"
    create_public_bucket "$BUCKET_NAME"
}

echo "Cuando el script se va ejecutando, la salida de cada comando sale en pantalla, presione 'q' para continuar..."

#se crea bucket para archivos
echo "Iniciando creación bucket para archivos..."
create_public_bucket_for "files"

#se crea bucket para turista
echo "Iniciando creación bucket para sitio web estático turista..."
create_website_for "turista"

#se crea bucket para comercios
echo "Iniciando creación bucket para sitio web estático comercios..."
create_website_for "comercios"

aws s3api list-buckets --query "Buckets[].Name"


