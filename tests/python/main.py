import sys
import traceback

from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    # Ensure transaction is active
    try:
        from newrelic.agent import current_transaction
        assert current_transaction(), "No active transaction."
    except Exception:
        return "".join(traceback.format_exception(*sys.exc_info())), 417
    
    # Ensure binary installation of agent is used
    from newrelic_k8s_operator import find_supported_newrelic_distribution
    new_relic_path = find_supported_newrelic_distribution()
    assert "linux" in new_relic_path, "Operator failed to find binary agent."

    # Return 200 OK response
    return "<p>Hello, World!</p><br><p>new_relic_path = %s</p>" % str(new_relic_path)
