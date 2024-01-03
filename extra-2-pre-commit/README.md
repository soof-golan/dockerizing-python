# Extra 2 - Pre Commit 🎣 (Moving complexity)

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

Now we'd like to cash in on pre-commit hooks. This will remove some of the complexity from our Dockerfile.

## Changes from previous step

* We added a `pre-commit` hook to our project.
* We used a pre-commit hook to export a `requirements.txt` file from our `pyproject.toml` and `poetry.lock` files
  outside of
  our Dockerfile.
* We dropped the `poetry-export` stage from our Dockerfile.

### New Files

* [`.pre-commit-config.yaml`](../.pre-commit-config.yaml) - The configuration file for pre-commit.

### Things that got better

* Our Dockerfile is almost back to its original simplicity.
* poetry.lock is the single source of truth for our dependencies with `requirements.txt` as a derived artifact.

### Things that got worse

* We added a dependency on `pre-commit` to our project.