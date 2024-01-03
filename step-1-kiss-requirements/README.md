# Step 1 - KISS Dockerized Python Image

This is the requirements.txt variant of the KISS Dockerized Python Image.

This will be our reference point for the rest of the examples and we will incrementally improve it to a full-fledged
production-ready image.

FWIW, I believe most project can just do fine with this base image without any further changes.

## What's in this folder?

* [`Dockerfile`](./Dockerfile) - The Dockerfile for the KISS image.
* [`requirements.txt`](./requirements.txt) - Our project's dependencies in their most basic form.
* [`kiss/main.py`](./kiss/main.py) - Our project's entry point.
  A [FastAPI server](https://fastapi.tiangolo.com/tutorial/first-steps/)
* [`.dockerignore`](./.dockerignore) - A file that tells Docker what to ignore when building the image.
* [`docker-compose.yml`](https://docs.docker.com/compose/compose-file/) - A file that tells Docker Compose how to run
  and build our image.
* [`gunicorn.conf.py`](./gunicorn.conf.py) - A configuration file for our production
  server executable, [gunicorn](https://gunicorn.org/).