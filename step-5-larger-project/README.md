# Step 5 - Larger Project

## TL;DR

For the impatient, you can always skip to the take The Red Pill 💊 and skip to
the [final result](../README.md#final-result) of the series.

## Table of Contents

* [Step 1 - Keep it simple stupid](../step-1-kiss-requirements/README.md) - A simple Dockerfile
* [Step 2 - Keep it simple - with Poetry](../step-2-kiss-poetry/README.md) - A simple Dockerfile with Poetry
* [Step 3 - Basic Improvements](../step-3-basic-improvements/README.md) - A more robust Dockerfile, with a few
  improvements
* [Step 4 - Nontrivial Improvements](../step-4-nontrivial-improvements/README.md) - Advanced Dockerfile features
* [Step 5 - Growing Pains](../step-5-larger-project/README.md) - Larger projects require extra care
* [Extra 1 - Compiling Dependencies](../extra-1-compiling-dependencies/README.md) - Handling packages that require
  compilation
* [Extra 2 - Need for Speed](../extra-2-need-for-speed/README.md) - Caching everything
* [Extra 3 - Moving Complexity](../extra-3-moving-complexity/README.md) - Moving complexity away from the Dockerfile
  into pre-commit hooks
* [Final Result](../README.md#final-result) - The final result of the series

### Running The Example

```bash
docker compose up --build
```

# What Changed?

Our project is getting larger and more complex. We now have a `tests/` folder, we have set up some linting and
formatting
tools, and we even have some development only dependencies. This is a good time to be more selective about what we put
in our production image, and what we leave out.

```dockerfile
FROM python:3.11 as poetry-export
RUN pip install poetry==1.7.0
WORKDIR /app
COPY poetry.lock pyproject.toml ./

# Excluded the `dev` dependencies
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

# This build stage stayed the same
FROM python:3.11 as server
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
COPY --from=poetry-export /app/requirements.txt ./
RUN pip install --require-hashes -r requirements.txt
COPY . .
RUN pip install . --no-deps
CMD ["gunicorn", "larger_project.main:app"]
```

## Changes from previous step

* We've got a `tests` folder
* We've got a `dev` dependency group in our `pyproject.toml`. it contains tools and packages that are only needed for
  development time.
* We explicitly excluded the `dev` dependency group from the exported `requirements.txt` file.
* We ignore everything by default in
  our [`.dockerignore`](https://docs.docker.com/build/building/context/#dockerignore-files) and Add back only what we
  need.

### New Files

* Our project source has been moved to a `src/` folder to signify we're more serious now.
    * this means we can have more than one python package in our project
* `tests/` - A folder containing our... umm... tests.

### Things that got better

* We no longer install development dependencies in our production image.
* Our [build context](https://docs.docker.com/build/building/context/) is as small as it can get.

## Things that got worse

* A _wee bit_ more complexity in our Dockerfile.
* The `.dockerignore` file is doing non-trivial load-bearing work

# Summary

This is a good time to take a step back and look at our Dockerfile. This will fit most projects' needs, but there are
still some dark corners of the python packaging ecosystem that we haven't explored yet. Let's fix that in

This is the [final Dockerfile (with some comments)](./verbose.Dockerfile) for this step:

```dockerfile
# Stage 1: Use `poetry export` to generate a `requirements.txt` file
# With SHA-256 hashes
FROM python:3.11 as poetry-export

# Install poetry
RUN pip install poetry==1.7.0

# Create the /app directory
WORKDIR /app

# Copy only the files needed for generating the requirements.txt file
COPY poetry.lock pyproject.toml ./

# Run poetry export to generate the requirements.txt file
# NOTE: We use --without dev to exclude development dependencies and
# --with prod to include production dependencies.
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

# Stage 2: Build the production image
FROM python:3.11 as server

# Configure Python to behave well inside the container.
# Do not write .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Do not buffer stdout and stderr
ENV PYTHONUNBUFFERED=1
# Display the Python stacktrace on error
ENV PYTHONFAULTHANDLER=1
# Do not check for pip updates
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Set the working directory to /app.
WORKDIR /app

# Copy only the requirements.txt file from Stage 1
COPY --from=poetry-export /app/requirements.txt ./

# Install dependencies.
RUN pip install --require-hashes -r requirements.txt

# Copy the rest of the codebase into the image.
# NOTE: .dockerignore determines what is (not) copied.
COPY . .

# Install our own project
RUN pip install . --no-deps

# Start the production server.
CMD ["gunicorn", "larger_project.main:app"]
```

[Extra 1](../extra-1-compiling-dependencies/README.md) - Compiling Dependencies
[Extra 2](../extra-2-need-for-speed/README.md) - Need for Speed
[Extra 3](../extra-3-moving-complexity/README.md) - Moving Complexity