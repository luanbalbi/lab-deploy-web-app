from flask import Flask, jsonify
import os
from datetime import datetime

app = Flask(__name__)

request_count = 0

@app.route('/')
def home():
    global request_count
    request_count += 1
    response = {
        "message": "SRE Application level 1",
        "version": os.getenv("APP_VERSION", "1.0.0"),
        "total_requests": request_count
    }
    return jsonify(response)

@app.route('/health')
def health():
    response = {
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)