# Step 4 - Nontrivial improvements over the Basic Dockerized Python Image

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

Now that we got the basics out of the way, let's make some nontrivial improvements to our image. These improvements will
make our image more robust, easier to debug and more friendly to container runtimes. Our final image is now more lean
and mean.

## Changes from previous step

* Drop poetry from the final image.
* We install the root pacakge with pip (instead of poetry).
* We use [multi-stage builds](https://docs.docker.com/build/building/multi-stage/) to generate a `requirements.txt`
  from `pyproject.toml` and `poetry.lock`.
* We added some environment variables that ensure Python is playing nicely with Docker.
    * [PYTHONFAULTHANDLER](https://docs.python.org/3.11/using/cmdline.html#envvar-PYTHONFAULTHANDLER) - Python will dump
      the Python traceback if it receives a fatal signal.
    * [PYTHONUNBUFFERED](https://docs.python.org/3.11/using/cmdline.html#envvar-PYTHONUNBUFFERED) - Python will not
      buffer stdout and stderr (let the host handle it)
    * [PYTHONDONTWRITEBYTECODE](https://docs.python.org/3.11/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE) - Python
      will not write `.pyc` files to disk.
    * [PIP_DISABLE_PIP_VERSION_CHECK](https://pip.pypa.io/en/stable/user_guide/#environment-variables) - Pip will not
      check for new versions of itself. (Mainly cleans up the logs)

### No new files ✨

### Things that got better

* Our builds are faster now (thanks to stage separation).
* We no use poetry in our final image.
    * As a side effect, we no longer use a virtual environment inside our container.
* Python is now configured to in a way that is more friendly to container runtimes.

### Things that got worse

* **Even more** complexity in our Dockerfile. (To our defense, the complexity is mostly shifted to the poetry stage.)
