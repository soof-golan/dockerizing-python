# Extra 1 - Need for Speed 🏎️ (Caching everything)

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

The Step 6 Image is already "production ready" for most projects' needs, but with some caching we can make it build even
faster.

## Changes from previous step

* We added [cache mounts](https://docs.docker.com/build/cache/) to our Dockerfile.
* The `poetry-export` stage now uses a `-slim` variant of the Python base image.
    * For the keen eyed of you: this is quite safe, as we only install poetry in this stage.

### Things that got better

* Our builds are even faster now (thanks to cache mounts, and a smaller base image for the `poetry-export` stage).
