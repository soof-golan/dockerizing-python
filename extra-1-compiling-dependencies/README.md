# Compiling Dependencies

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

Our project has grown a bit, and we added a database to it. We're now
using [psycopg2](https://pypi.org/project/psycopg2/)
to connect to our database. problem is, psycopg2 is a C extension that needs to
be [compiled from source](https://www.psycopg.org/docs/install.html#psycopg-vs-psycopg-binary). This means we
need to install the build tools and the postgresql development libraries in our image.

Our [Dockerfile](./Dockerfile) hasn't changed, but we may need to install some extra dependencies in our image.

```dockerfile
FROM python:3.11 as poetry-export
RUN pip install poetry==1.7.0
WORKDIR /app
COPY poetry.lock pyproject.toml ./
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

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
CMD ["gunicorn", "compiling_depenedencies.main:app"]
```

## Changes from previous step

* We added psycopg2 to our production dependencies.
* We added psycopg2-binary to our development dependencies.

### New Files

* `slim.Dockerfile` - A variant of our Dockerfile that uses the `-slim` variant of the Python base image.

### Things that got better

* We only pay for compilation when we're building the production image. During development, we use the pre-compiled
  binary.

## Things that got worse

* Our local development environment is now slightly different from our production environment. (Not exactly related to
  this Docker, just something to keep in mind)

## An aside on building packages from source (Or: Beware of `-slim` Variants)

Python packages that require compilation of native code (Examples: pycurl, psycopg2) usually need supporting libraries
to compile successfully. This is usually not a problem when using the regular Python base image, but it will hurt you
when using the _`-slim`_ variant, which usually misses the development libraries you need.

If you like suffering from using `apt-get`, you can install the build dependencies for the packages you need. See the
[`slim.Dockerfile`](./slim.Dockerfile) variant in this folder for an example.

Also - **Stay away from `alpine` images** unless you have excellent reasons to use them. You don't want to deal with the
ABI / compilation hell that is `musl` vs `glibc` with python packages.

# Summary

You've made it this far, and you now have a production ready Dockerfile. Congratulations!
We've covered a lot of ground, and you should now have a good understanding of how to build a Dockerfile for your
project [~~FROM scratch~~](https://hub.docker.com/_/scratch/).

We've got 2 extra steps to go, but they're not strictly necessary, but they will make your life easier in the long run.
Check out [Extra 1 - Need For Speed](/extra-2-need-for-speed/README.md)
and [Extra 2 - Moving Complexity](/extra-3-moving-complexity/README.md) for more details.

```dockerfile
FROM python:3.11-slim as poetry-export
RUN pip install poetry==1.7.0
WORKDIR /app
COPY poetry.lock pyproject.toml ./
RUN poetry export \
    --without dev \
    --with prod \
    --output requirements.txt \
    --format requirements.txt

# The -slim image is missing some build dependencies
FROM python:3.11-slim as server

# Install build dependencies for psycopg2
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoremove -y

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
COPY --from=poetry-export /app/requirements.txt ./
RUN pip install --require-hashes -r requirements.txt
COPY . .
RUN pip install . --no-deps
CMD ["gunicorn", "compiling_depenedencies.main:app"]
```