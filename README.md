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

# Setup

        $ make init

# Build

        $ make all

Creates a Docker container to build the snap, builds the snap, test installs
the snap in the same container, and finally copies the snap to local
filesystem.

# Clean

* Destroys the container

# Destroy

* Run all steps in *clean*
* Removes the snap from the local filesystem

# Notes

Tests fail when running them on Ubuntu based Docker host. They work when
running on macOS. There appears to be an issue with AppArmor on Ubuntu.
