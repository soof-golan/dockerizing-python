# Extra 1 - Need for Speed 🏎️ (Caching everything)

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
* [Step 6 - Compiling Dependencies](../step-6-compiling-dependencies/README.md) - Handling packages that require
  compilation
* [Extra 1 - Need for Speed](../extra-1-need-for-speed/README.md) - Caching everything
* [Extra 2 - Moving Complexity](../extra-2-pre-commit/README.md) - Moving complexity away from the Dockerfile into
  pre-commit hooks
* [Final Result](../README.md#final-result) - The final result of the series

### Running The Example

```bash
docker compose up --build
```

# What Changed?

The Step 6 Image is already "production ready" for most projects' needs, but with some caching we can make it build even
faster.

```dockerfile
# We're not compiling anything here, so we can use a -slim image for the export stage.
FROM python:3.11-slim as poetry-export

# Utilize pip's dependency cache for faster builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install poetry==1.7.0

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

# Utilize pip's dependency cache for faster builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --require-hashes -r requirements.txt

COPY . .

# Utilize pip's dependency cache for faster builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install . --no-deps

# Compile "all" Python files in the PYTHONPATH to bytescode (10 levels deep)
RUN python -m compileall $(python -c "import sys; print(' '.join(sys.path), end='')") -r 10

CMD ["gunicorn", "need_for_speed.main:app"]
```

## Changes from previous step

* We added [cache mounts](https://docs.docker.com/build/cache/) to our Dockerfile.
* The `poetry-export` stage now uses a `-slim` variant of the Python base image.
    * For the keen eyed of you: this is quite safe, as we only install poetry in this stage.
* We pre-compile all Python files in the image.

### Things that got better

* Our builds are even faster now (thanks to cache mounts, and a smaller base image for the `poetry-export` stage).
* Startup time is slightly faster due to pre-compiling the python bytecode.

### Things that got worse

* Our image is now slightly larger due to the `compileall` step.

# Summary

Now your builds are even faster, but there's still some complexity in the Dockerfile. Let's move that complexity away
from
the Dockerfile in [Extra 2 - Moving Complexity](../extra-2-pre-commit/README.md)

Alternatively, if you already read that, you can jump to the [final result](../README.md#final-result) of the series.