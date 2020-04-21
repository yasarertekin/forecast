# forecast
Forecast assessment with AWS Cloudformation, AWS Lambda, S3 Bucket, AWS IAM, NodeJS and MongoDB Atlas

## Available Scripts

In the project directory, you can run:

### `npm run  create-stack`

#### Create S3 Bucket, Cloudformation stack, and deploy the Lambda's. Validate also the Cloudformation stack.

#### In the file config.env you can specify:
- `STACK_NAME` Name your stack
- `S3_BUCKET_NAME` Name your AWS Bucket
- `S3_BUCKET_REGION`  The AWS Region you want to deploy in
- `URI_MONGO_DB`  The URI of the too used Mongo DB Atlas
- `URL_WEATHER_FORECAST` The URL of the Weather cast site you want to use


### `npm run  update-stack`
#### Run after change, it will also versioned your changes. Validate also the Cloudformation stack.

### `npm run  delete-stack`
#### Delete the stack and remove also the S3 Bucket you created.

### `npm run test`

#### Runs jest test

## API

### GET avgTempInSfax

#### Returns the temperature (celsius) average, min and max in Sfax, Tunisia in June

### GET currentTempInCovilha

#### Returns the current temperature (celsius) in Covilha, Portugal and the respective timestamp of the reading. 
#### Saves the reading on mongodb Atlas.
