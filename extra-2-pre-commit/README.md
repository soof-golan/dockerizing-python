# Extra 2 - Pre Commit

Now we'd like to cash in on pre-commit hooks this will remove some of the complexity from our Dockerfile.

## Changes from previous step

* We added a `pre-commit` hook to our project.
* We used a pre-commit hook to export a `requirements.txt` file from our `pyproject.toml` and `poetry.lock` files outside of
  our Dockerfile.
* We dropped the `poetry-export` stage from our Dockerfile.

### New Files

* [`.pre-commit-config.yaml`](../.pre-commit-config.yaml) - The configuration file for pre-commit.

### Things that got better

* Our Dockerfile is almost back to its original simplicity.
* poetry.lock is the single source of truth for our dependencies with `requirements.txt` as a derived artifact.

### Things that got worse

* We added a dependency on `pre-commit` to our project.

