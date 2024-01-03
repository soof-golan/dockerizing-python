# Step 4 - Nontrivial improvements over the Basic Dockerized Python Image

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

