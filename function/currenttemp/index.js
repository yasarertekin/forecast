"use strict";
const MongoClient = require('mongodb').MongoClient;
const _ = require('lodash');
const fetch = require('node-fetch');

let MONGODB_URI;
let WEATHER_FORECAST_URL;
let cachedDb;
const FORMAT_URL = ',pt&format=json&u=c';

exports.handler = async (event, context, callback) => {
    MONGODB_URI = process.env['URI_MONGO_DB'];
    WEATHER_FORECAST_URL = process.env['URL_WEATHER_FORECAST'];

    if (WEATHER_FORECAST_URL == null) {
        console.error('Missing Weather forecast URL');
        callback(null, responseConverter(500, {error: "Missing Weather forecast URL"}));
    } else {
        if (MONGODB_URI != null) {
            await processEvent(event, context, callback);
        } else {
            console.error('Missing  Mongo DB URI');
            callback(null, responseConverter(500, {error: "Missing Mongo DB URI"}));
        }
    }
};

async function processEvent(event, context, callback) {
    let forecastContents;

    //the following line is critical for performance reasons to allow re-use of database connections across calls to this Lambda function and avoid closing the database connection. The first call to this lambda function takes about 5 seconds to complete, while subsequent, close calls will only take a few hundred milliseconds.
    context.callbackWaitsForEmptyEventLoop = false;


    try {
        const response = await fetch(WEATHER_FORECAST_URL + FORMAT_URL);
        const body = await response.json();
        const {current_observation: {condition: {temperature}}} = body;
        const currentTimeStamp = Math.floor(Date.now() / 1000);
        forecastContents = {temperature: temperature, timestamp: currentTimeStamp};

        //testing if the database connection exists and is connected to Atlas so we can try to re-use it
        if (cachedDb && cachedDb.serverConfig.isConnected()) {
            return createDoc(cachedDb, forecastContents, callback);
        } else {
            //some performance penalty might be incurred when running that database connection initialization code
            await MongoClient.connect(MONGODB_URI,  { useUnifiedTopology: true }, function (err, client) {
                if (err) {
                    console.error(`the error is ${err}.`, err);
                    process.exit(1)
                }
                cachedDb = client.db('forecast');
                return createDoc(cachedDb, forecastContents, callback);

            });
        }
    } catch (err) {
        console.error('an error occurred to connect with forecast site', err);
        callback(null, responseConverter(500, {error: err}));
    }
}

async function createDoc(db, forecast, callback) {
    try {
        await db.collection('covilha').insertOne(forecast);
        callback(null, responseConverter(200, forecast));
    } catch (err) {
        console.error("an error occurred in createDoc", err);
        callback(null, responseConverter(500, {error: err}));
    }
}

function responseConverter(statusCode, message) {
    return {statusCode: statusCode, body: JSON.stringify(message)}
}
