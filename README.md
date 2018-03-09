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

This is an all-in-one target that runs the *build*, *test*, and *promote* steps.

        $ make build

Creates a container to build the snap and builds the snap.

, test installs
the snap in the same container, and finally copies the snap to local
filesystem.

        $ make test

The *test* target is only supported on local build with ``make``. Creates a
container to copy out the snap. Creates another container to install the snap
and test that it works.

        $ make promote-snap

Copies snap from *test* directory to a newly created *snap* directory. This
means the snap is ready for distribution.

# Clean

        $ make clean

* Destroys the container

# Destroy

        $ make destroy

* Run all steps in *clean*
* Removes the snap from the local filesystem
* Removes any directories created in ``make`` target(s)

# Notes

Tests fail when running them on Ubuntu based Docker host. They work when
running on macOS. There appears to be an issue with AppArmor on Ubuntu.

# Codefresh CI

It is tied to github.com/aikchar/snap-python37 and runs new builds on pushed
commits.

# Concourse CI

        $ fly --target TARGET execute --privileged --config=concourseci-build.yml --input build_root=./build --output snap=./test

For a one-off build in Concourse CI, run the above command. The only thing you
need to change is *TARGET* to the appropriate *target* for your environment.

Once you have the snap in the *test* directory, you can run ``make test``
locally.
