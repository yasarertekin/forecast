exports.handler = async (event) => {
    console.log('Event', event);

    const responseBody = {minTemp: 19, maxTemp: 30, average: 24.5};

    try {
        return responseConverter(200, responseBody)
    } catch (err) {
        console.log("Error response", err);
        return responseConverter(500, {error: err})
    }
};
function responseConverter(statusCode, message) {
    return {statusCode: statusCode, body: JSON.stringify(message)}
}
