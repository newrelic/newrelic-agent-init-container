const http = require('http')

const PAYLOAD = JSON.stringify({ msg: 'ok' })

const PAGE =
    '<html>' +
    '<head><title>test response</title></head>' +
    '<body><p>I heard you like HTML.</p></body>' +
    '</html>'


function makeRequest(params, cb) {
    const req = http.request(params, function (res) {
        if (res.statusCode !== 200) {
            return cb(null, res.statusCode, null)
        }

        res.setEncoding('utf8')
        res.on('data', function (data) {
            cb(null, res.statusCode, data)
        })
    })

    req.on('error', function (err) {
        // If we aborted the request and the error is a connection reset, then
        // all is well with the world. Otherwise, ERROR!
        if (params.abort && err.code === 'ECONNRESET') {
            cb()
        } else {
            cb(err)
        }
    })

    if (params.abort) {
        setTimeout(function () {
            req.abort()
        }, params.abort)
    }
    req.end()
}

function startServer () {
    const external = http.createServer(function (request, response) {
        response.writeHead(200, {
            'Content-Length': PAYLOAD.length,
            'Content-Type': 'application/json'
        })
        response.end(PAYLOAD)
    })

    const server = http.createServer(function (request, response) {
        if (/\/slow$/.test(request.url)) {
            setTimeout(function () {
                response.writeHead(200, {
                    'Content-Length': PAGE.length,
                    'Content-Type': 'text/html'
                })
                response.end(PAGE)
            }, 500)
            return
        }
        makeRequest(
            {
                port: 8000,
                host: 'localhost',
                path: '/status',
                method: 'GET'
            },
            function () {
                response.writeHead(200, {
                    'Content-Length': PAGE.length,
                    'Content-Type': 'text/html'
                })
                response.end(PAGE)
            }
        )
    })

    return new Promise((resolve) => {
        external.listen(8000, '0.0.0.0', function () {
            server.listen(8001, '0.0.0.0', function () {
                // The transaction doesn't get created until after the instrumented
                // server handler fires.
                resolve()
            })
        })
    })
}

startServer()

