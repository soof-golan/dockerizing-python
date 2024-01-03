# Step 2 - KISS Dockerized Python Image with Poetry

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

# What Changed?

This is the poetry variant of the KISS Dockerized Python Image.

## Changes from previous step

* We added [Poetry](https://python-poetry.org/) to our project.
* We're now managing our dependencies with poetry instead of a requirements.txt file.

### New Files

* [`pyproject.toml`](./pyproject.toml) - A file that tells poetry how to manage our project.
* [`poetry.lock`](./poetry.lock) - A lock file that tells poetry how to reproduce our project's dependencies.

### Things that got better

* poetry's lock file guarantees reproducibility across different machines.

### Things that got worse

* poetry is a new dependency that we have to manage.
* poetry will create a virtual environment for us, which means we have to activate it before we can run our project.
* This virtual environment also exists within our container.
