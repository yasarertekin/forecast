#!/bin/bash

CURRENT_TEMP_FUNCTION_VERSION=$(./FooFunction/build.sh)
AVERAGE_TEMP_FUNCTION_VERSION=$(./function/currenttemp/build.sh)


aws cloudformation update-stack \
  --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
  ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME \
  ParameterKey=CurrentTempFunctionVersion,ParameterValue=$CURRENT_TEMP_FUNCTION_VERSION \
  ParameterKey=AverageTempFunctionVersion,ParameterValue=$AVERAGE_TEMP_FUNCTION_VERSION \


echo "Updating..."

aws cloudformation wait stack-update-complete --stack-name $STACK_NAME
