from flask import Flask, abort

app = Flask(__name__)

@app.route("/")
def hello_world():
    try:
        from newrelic.agent import current_transaction
        assert current_transaction(), "No active transaction."
    except Exception:
        abort(417)
    
    return "<p>Hello, World!</p>"
