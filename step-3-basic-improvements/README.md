# Step 3 - Basic improvements over the KISS Dockerized Python Image

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

