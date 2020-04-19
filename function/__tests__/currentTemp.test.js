jest.mock('node-fetch');
const MongoClient = require('mongodb').MongoClient;
const Response = require('node-fetch');
const fetch = require('node-fetch');

const {handler} = require('../currenttemp');
const URL_WEATHER = 'anyurl';
const MONGODB = 'anyuri';

let connection;
let db;
beforeAll(async () => {
    connection = await MongoClient.connect(global.__MONGO_URI__);
    db = await connection.db(global.__MONGO_DB_NAME__);
});

afterAll(async () => {
    await connection.close();
});

test('currentTemp: check if the weather forecast is hit 1, and check MongDB insert works', async (done) => {
    fetch.mockReturnValue(Promise.resolve(new Response('4')));

    const forecast = db.collection('covilha');
    const mockForeCast = {_id: 1, temperature: 10, timestamp: '12345'};

    process.env.URL_WEATHER_FORECAST = URL_WEATHER;
    process.env.URI_MONGO_DB = MONGODB;

    const eventStub = {min: 10, max: 30};
    try {
        const callback = () => {
            done();
        };
        await handler(eventStub, {}, callback());
        const insertedForecast = await forecast.insertOne(mockForeCast);
        expect(insertedForecast).toEqual(mockForeCast);
        done();
    } catch (err) {
        done();
    }

    expect(fetch).toHaveBeenCalledTimes(1);

});
