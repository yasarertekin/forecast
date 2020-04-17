#!/bin/bash

aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $S3_BUCKET_REGION --create-bucket-configuration LocationConstraint=$S3_BUCKET_REGION
echo "Creating Bucket..."
./function/averagetemp/build.sh
./function/currenttemp/build.sh

aws cloudformation create-stack --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
    ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME --capabilities CAPABILITY_NAMED_IAM

echo "Creating..."

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
