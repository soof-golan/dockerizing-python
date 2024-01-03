# Step 6 - Compiling Dependencies

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

Our project has grown a bit, and we added a database to it. We're now
using [psycopg2](https://pypi.org/project/psycopg2/)
to connect to our database. problem is, psycopg2 is a C extension that needs to
be [compiled from source](https://www.psycopg.org/docs/install.html#psycopg-vs-psycopg-binary). This means we
need to install the build tools and the postgresql development libraries in our image.

## Changes from previous step

* We added psycopg2 to our production dependencies.
* We added psycopg2-binary to our development dependencies.

### New Files

* `slim.Dockerfile` - A variant of our Dockerfile that uses the `-slim` variant of the Python base image.

### Things that got better

* We only pay for compilation when we're building the production image. During development, we use the pre-compiled
  binary.

## Things that got worse

* Our local development environment is now slightly different from our production environment. (Not exactly related to
  this Docker, just something to keep in mind)

## An aside on building packages from source (Or: Beware of `-slim` Variants)

Python packages that require compilation of native code (Examples: pycurl, psycopg2) usually need supporting libraries
to compile successfully. This is usually not a problem when using the regular Python base image, but it will hurt you
when using the _`-slim`_ variant, which usually misses the development libraries you need.

If you like suffering from using `apt-get`, you can install the build dependencies for the packages you need. See the
`slim.Dockerfile` variant in this folder for an example.

Also - **Stay away from `alpine` images** unless you have excellent reasons to use them. You don't want to deal with the
ABI / compilation hell that is `musl` vs `glibc` with python packages.