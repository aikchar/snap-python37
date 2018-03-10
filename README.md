# Python 3.7 Snap

Build a snap that would install Python 3.7.

## Why?

Linux, unlike BSDs, does not have a "ports" system where upstream distro
provides multiple versions of Python for a single version of the distro. For
example, Ubuntu 16.04 Xenial comes with Python 3.5 but it will never get newer
Python versions in its official repos. To install Python 3.7 in Ubuntu 16.04,
one has to build it from source, use something like pkgsrc, something else, or
use a snap. I chose the route of building a snap.

## How

The *stage-packages* has a long list of packages. This list was obtained from
``apt build-dep python3.6`` on Ubuntu 17.10 Artful. I removed all packages that
had *python-* or *python3-* in their name. That didn't appear to have any
negative impact.

# Requirements

## Local Build

* Docker
* Python 3.6+
* pipenv
* GNU make

## Concourse CI

* Access to Concourse (perhaps [docker-compose-concourse-ci](https://github.com/codeghar/docker-compose-concourse-ci)?)
* Access to `fly` cli

# Setup

        $ make init

# Build, Test, Promote

        $ make all

This is an all-in-one target that runs the *build*, *get-snap*, *test*, and
*clean* steps.

        $ make build

Creates a container to build the snap and builds the snap.


        $ make get-snap

Creates a container to copy out the snap to the *snap* directory.

        $ make test

Creates a container to install the snap and test that it works.

# Clean

        $ make clean

* Destroys any container created in this workflow

# Destroy

        $ make destroy

* Run all steps in *clean*
* Removes the snap from local filesystem
* Removes any directories created in ``make`` target(s)

# Notes

Tests fail when running them on Ubuntu based Docker host. They work when
running on macOS. There appears to be an issue with AppArmor on Ubuntu.

# Codefresh CI

It is tied to github.com/aikchar/snap-python37 and runs new builds on pushed
commits.

# Concourse CI

        $ fly --target TARGET execute --privileged --config=./ci/concourse/build.yml --input snap-python37-src=. --output snap-python37-artifacts=/tmp

For a one-off build in Concourse CI, run the above ``fly`` command. The only
thing you need to change is *TARGET* to the appropriate *target* for your
environment.

        $ . .envrc
        $ make init
        $ cp /tmp/"${PYTHON_SNAP}" ./snap
        $ make test

Once you have the snap artifact in the *snap* directory, you can run
``make test`` locally.

# Customization

As newer releases of Python 3.7 appear on Git Hub, make these changes:

* Update *PYTHON37_VERSION* in *.envrc* file
* Update *version* and *source-tag* in *build/snapcraft.yaml*
* Update *PYTHON37_VERSION* in *ci/codefresh/codefresh.yml*
* Optional: update *ARG PYTHON37_VERSION* in *build/Dockerfile* to keep up
