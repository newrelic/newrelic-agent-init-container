import newrelic.agent
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    transaction = newrelic.agent.current_transaction()
    if not transaction:
        flask.abort(417)
    return "<p>Hello, World!</p>"
