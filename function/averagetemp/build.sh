#!/bin/bash

{
  rm AverageTempFunction.zip
  cd AverageTempFunction; zip -r ../AverageTempFunction.zip *; cd ..;
} &> /dev/null

Version=$(md5sum -b AverageTempFunction.zip | awk '{print $1}')

{
  aws s3 cp AverageTempFunction.zip s3://$S3_BUCKET_NAME/AverageTempFunction-$Version.zip
  aws s3 cp AverageTempFunction.zip s3://$S3_BUCKET_NAME/AverageTempFunction-latest.zip
  rm AverageTempFunction.zip
} &> /dev/null

echo $Version
