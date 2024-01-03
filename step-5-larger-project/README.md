# Step 5 - Larger Project

## TL;DR

For the impatient, you can always skip to the [final result](/README.md#final-result) of the series.

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

# What Changed?

Our project is getting larger and more complex. We now have a `tests/` folder, we have set up some linting and
formatting
tools, and we even have some development only dependencies. This is a good time to be more selective about what we put
in our production image, and what we leave out.

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
