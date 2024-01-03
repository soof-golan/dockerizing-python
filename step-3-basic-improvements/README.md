# Step 3 - Basic improvements over the KISS Dockerized Python Image

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

There are some basic improvements we can make to the image we created in the previous step that will significantly
improve our experience with it.

## Changes from previous step

* We pinned the poetry version to the latest stable version (as of time of writing: 1.7.0).
* We split up the installation of the project dependencies and the installation of the project itself.

### No new files ✨

### Things that got better

* We're now protected from poetry being updated to a version that breaks our project.
* Splitting the dependency installation utilizes Docker's _layer_ caching mechanism. (our builds are now faster)

### Things that got worse

* More lines of code in our Dockerfile.

