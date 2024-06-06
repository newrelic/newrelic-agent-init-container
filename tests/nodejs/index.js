const http = require('http')

const PAYLOAD = JSON.stringify({ msg: 'ok' })

function startServer () {
    const server = http.createServer(function (request, response) {
        response.writeHead(200, {
            'Content-Length': PAYLOAD.length,
            'Content-Type': 'application/json'
        })
        response.end(PAYLOAD)
    })

    return new Promise((resolve) => {
        server.listen(8000, 'localhost', function () {
            // The transaction doesn't get created until after the instrumented
            // server handler fires.
            resolve()
        })
    })
}

startServer()

