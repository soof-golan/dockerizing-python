# Step 3 - Basic improvements over the KISS Dockerized Python Image

## TL;DR

For the impatient, you can always skip to the take The Red Pill 💊 and skip to
the [final result](/README.md#final-result) of the series.

## Table of Contents

* [Step 1 - Keep it simple stupid](/step-1-kiss-requirements/README.md) - A simple Dockerfile
* [Step 2 - Keep it simple - with Poetry](/step-2-kiss-poetry/README.md) - A simple Dockerfile with Poetry
* [Step 3 - Basic Improvements](/step-3-basic-improvements/README.md) - A more robust Dockerfile, with a few
  improvements
* [Step 4 - Nontrivial Improvements](/step-4-nontrivial-improvements/README.md) - Advanced Dockerfile features
* [Step 5 - Growing Pains](/step-5-larger-project/README.md) - Larger project require extra care
* [Step 6 - Compiling Dependencies](/step-6-compiling-dependencies/README.md) - Handling packages that require
  compilation
* [Extra 1 - Need for Speed](/extra-1-need-for-speed/README.md) - Caching everything
* [Extra 2 - Moving Complexity](/extra-2-pre-commit/README.md) - Moving complexity away from the Dockerfile into
  pre-commit hooks
* [Final Result](/README.md#final-result) - The final result of the series

### Running The Example

```bash
docker compose up --build
```

# What Changed?

There are some basic improvements we can make to the image we created in the previous step that will significantly
improve our experience with it.

```dockerfile
FROM python:3.11

# Pin poetry version to avoid breaking changes
RUN pip install poetry==1.7.0

WORKDIR /app

# Copy only the files needed for installing dependencies
COPY poetry.lock pyproject.toml ./

# Only install external dependencies
RUN poetry install --no-root --with prod

# Copy the rest of the code
COPY . .

# Install our own project
RUN poetry install

CMD ["poetry", "run", "gunicorn", "basic_improvements.main:app"]

```

## Changes from previous step

* We pinned the poetry version to the latest stable version (as of time of writing: 1.7.0).
* We split up the installation of external dependencies and the installation of the project itself to separate steps.

### No new files ✨

### Things that got better

* We're now protected from poetry being updated to a version that breaks our project.
* Splitting the dependency installation to 2 steps utilizes Docker's _layer_ caching mechanism. (our builds are now
  faster)

### Things that got worse

* More lines of code in our Dockerfile.

# Summary

Our container is in much better shape now, but there are still some things we can improve that are more on the advanced
side of things. Let's do that in [Step 4](/step-4-nontrivial-improvements/README.md)