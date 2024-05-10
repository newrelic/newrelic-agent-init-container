from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    from newrelic.agent import current_transaction
    assert current_transaction(), "No active transaction."
    
    return "<p>Hello, World!</p>"
