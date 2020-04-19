const { handler } = require('../averagetemp');

test('test Average Temp Ok}', async () => {
    const { body } = await handler({});
    const data = JSON.parse(body);
    expect(data).toStrictEqual({ minTemp: 19, maxTemp: 30, average: 24.5 });
});
