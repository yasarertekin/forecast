#!/bin/bash

echo "Uploading project to the bucket.."
CURRENT_TEMP_FUNCTION_VERSION=$(./function/currenttemp/build.sh)
AVERAGE_TEMP_FUNCTION_VERSION=$(./function/averagetemp/build.sh)


echo "Validating stack..."
aws cloudformation validate-template --template-body file://cloudformation.yaml


echo "Updating the stack..."
aws cloudformation update-stack \
  --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
  ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME \
  ParameterKey=CurrentTempFunctionVersion,ParameterValue=$CURRENT_TEMP_FUNCTION_VERSION \
  ParameterKey=AverageTempFunctionVersion,ParameterValue=$AVERAGE_TEMP_FUNCTION_VERSION \
  ParameterKey=MongoDBURI,ParameterValue=$URI_MONGO_DB \
  ParameterKey=WeatherForeCastURL,ParameterValue=$URL_WEATHER_FORECAST

echo "Updating..."

aws cloudformation wait stack-update-complete --stack-name $STACK_NAME
