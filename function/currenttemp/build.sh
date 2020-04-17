#!/bin/bash

{
  rm CurrentTempFunction.zip
  cd CurrentTempFunction; zip -r ../CurrentTempFunction.zip *; cd ..;
} &> /dev/null

Version=$(md5sum -b CurrentTempFunction.zip | awk '{print $1}')

{
  aws s3 cp CurrentTempFunction.zip s3://$S3_BUCKET_NAME/CurrentTempFunction-$Version.zip
  aws s3 cp CurrentTempFunction.zip s3://$S3_BUCKET_NAME/CurrentTempFunction-latest.zip
  rm CurrentTempFunction.zip
} &> /dev/null

echo $Version
