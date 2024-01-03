# Step 1 - KISS Dockerized Python Image

## TL;DR

For the impatient, you can always skip to the [final result](/README.md#final-result) of the series.

## Table of Contents

* [Step 1 - Keep it simple stupid](/step-1-kiss-requirements/README.md) - A simple Dockerfile
* [Step 2 - Keep it simple - with Poetry](/step-2-kiss-poetry/README.md) - A simple Dockerfile with Poetry
* [Step 3 - Basic Improvements](/step-3-basic-improvements/README.md) - A more robust Dockerfile, with a few improvements
* [Step 4 - Nontrivial Improvements](/step-4-nontrivial-improvements/README.md) - Advanced Dockerfile features
* [Step 5 - Growing Pains](/step-5-larger-project/README.md) - Larger project require extra care
* [Step 6 - Compiling Dependencies](/step-6-compiling-dependencies/README.md) - Handling packages that require
  compilation
* [Extra 1 - Need for Speed](/extra-1-need-for-speed/README.md) - Caching everything
* [Extra 2 - Moving Complexity](/extra-2-pre-commit/README.md) - Moving complexity away from the Dockerfile into
  pre-commit hooks
* [Final Result](/README.md#final-result) - The final result of the series

# A Starting Point

This is the requirements.txt variant of the KISS Dockerized Python Image.

This will be our reference point for the rest of the examples, and we will incrementally improve it to a full-fledged
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