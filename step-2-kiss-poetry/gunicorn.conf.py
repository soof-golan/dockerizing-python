"""Gunicorn configuration file.

https://docs.gunicorn.org/en/stable/configure.html
https://docs.gunicorn.org/en/stable/settings.html
"""

import os

host = os.environ.get("HOST", "0.0.0.0")
port = os.environ.get("PORT", "8000")

bind = f"{host}:{port}"
workers = os.environ.get("WORKERS", os.cpu_count() * 2 + 1)

# Worker class for handling requests.
worker_class = "uvicorn.workers.UvicornWorker"

# Logging configuration.
accesslog = "-"
errorlog = "-"
loglevel = "info"
