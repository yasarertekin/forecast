#!/bin/bash



echo "Creating Bucket..."
aws s3api create-bucket --bucket $S3_BUCKET_NAME --region $S3_BUCKET_REGION --create-bucket-configuration LocationConstraint=$S3_BUCKET_REGION


echo "Uploading project to the bucket.."
./function/averagetemp/build.sh
./function/currenttemp/build.sh

echo "Validating stack..."
aws cloudformation validate-template --template-body file://cloudformation.yaml

echo "Creating stack..."
aws cloudformation create-stack --stack-name=$STACK_NAME \
  --template-body=file://cloudformation.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
    ParameterKey=S3BucketName,ParameterValue=$S3_BUCKET_NAME  \
    ParameterKey=MongoDBURI,ParameterValue=$URI_MONGO_DB \
    ParameterKey=WeatherForeCastURL,ParameterValue=$URL_WEATHER_FORECAST \
    --capabilities CAPABILITY_NAMED_IAM

echo "Creating..."

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
