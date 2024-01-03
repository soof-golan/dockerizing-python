# Extra 1 - Need for Speed 🏎️

The Step 5 Image is already production ready for projects' needs, but we add some elbow grease to make it even better.

## Changes from previous step

* We added [cache mounts](https://docs.docker.com/build/cache/) to our Dockerfile.
* The `poetry-export` stage now uses a `-slim` variant of the Python base image.
    * For the keen eyed of you: this is quite safe, as we only install poetry in this stage.

### Things that got better

* Our builds are even faster now (thanks to cache mounts, and a smaller base image for the `poetry-export` stage).
