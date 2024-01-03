# Step 2 - KISS Dockerized Python Image with Poetry

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

