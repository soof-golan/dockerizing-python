# Dockerizing Python

This repository contains a series of examples on how to Dockerize Python applications. I tried to make each stage
"production ready", so you should be able to use any of them as a starting point for your own project.

You can follow along with the video on YouTube: [!TODO]

In each step, we will add a new feature to our Dockerfile, each addition will trade off somthing for something else.
The goal is to end up with a Dockerfile that is both simple, robust and easy to maintain.

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

## Pre-requisites

To follow along with this series, you will need the following pieces of software installed + a basic understanding of
how to use them:

* [Docker](https://docs.docker.com/get-docker/) - A container runtime
* [Python 3.11](https://www.python.org/downloads/) (Anything above 3.9 should work)
* [Poetry](https://python-poetry.org/docs/#installation) - A Python package manager
* [Pre-commit](https://pre-commit.com/#install) - A tool for managing pre-commit hooks

# Final Result

Congratulations! You've reached the end of the series. This is our final [Dockerfile 🐳](Dockerfile):

```dockerfile
# Use the official Python image. Beware of -slim or -alpine here!
FROM python:3.11

# Configure Python to behave well inside the container.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set the working directory to /app.
WORKDIR /app

# Copy only the (auto-generated) requirements.txt file
COPY ./requirements.txt ./

# Install dependencies (with caching).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --require-hashes -r requirements.txt

# Copy the rest of the codebase into the image.
COPY . .

# Install the "root" application (with caching).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install . --no-deps

# Start the production server.
CMD ["gunicorn", "dockerizing_python.main:app"]
```

This file contains all the bells and whistles we've added throughout the series.

## Summary of all the good stuff we did

* Our project is managed with [Poetry](https://python-poetry.org/).
* We separate our dependencies into 3 groups, this gives us granular control over what we install in our image:
    * _common_ - Dependencies that are needed for both development and production.
    * _dev_ - Dependencies that are only needed for development.
    * _prod_ - Dependencies that are only needed for production.
* We use `poetry export` to generate a `requirements.txt` file. (
  see [step-4-nontrivial-improvements](step-4-nontrivial-improvements/README.md))
    * Optionally with a [Pre-commit](https://pre-commit.com/) hook to keep it up to date. (
      see [extra-2-pre-commit](extra-2-pre-commit/README.md))
* We use utilize Docker's [build cache](https://docs.docker.com/build/cache/) to speed up our builds. (see
  [extra-1-need-for-speed](extra-1-need-for-speed/README.md))
* We only copy what we need into the build context with [`.dockerignore`](./.dockerignore)

## Summary of all the stuff we avoided

* We managed to get away without multi-stage builds (sometime this is necessary, but not in our case).
* We avoid -slim and -alpine variants of the Python base image.
* We avoided using a virtual environment inside the container.