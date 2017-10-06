import os
from flask import Flask
from flask import jsonify

from utils import to_bool

POD_NAME = os.environ.get("POD_NAME")
POD_IP = os.environ.get("POD_IP")
NODE_NAME = os.environ.get("NODE_NAME")

app = Flask(__name__)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True

@app.route('/')
def meta():
    return jsonify({
        'META': 'Here is some info about this pod',
        'POD_NAME': POD_NAME,
        'POD_IP': POD_IP,
        'NODE_NAME': NODE_NAME,
    })

if __name__ == '__main__':
    app.run(
        debug=to_bool(os.environ.get('DEBUG')),
        host='0.0.0.0'
    )
