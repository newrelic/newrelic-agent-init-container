import os
import sys
import traceback

from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    try:
        from newrelic.agent import current_transaction, add_custom_attribute

        assert current_transaction(), "No active transaction."
        add_custom_attribute("testKey", os.getenv("SCENARIO_TAG", "NOTSET"))
    except Exception:
        return "".join(traceback.format_exception(*sys.exc_info())), 417

    return "<p>Hello, World!</p>"
