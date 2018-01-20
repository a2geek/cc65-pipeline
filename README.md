# cc65 build agent

This Docker image is intended to be used in a build pipeline to build
6502/65c02/65816 projects.  It is simply a blend of
[Alpine Linux](https://alpinelinux.org/) and
[cc65](http://cc65.github.io/cc65/).

In an effort to keep the image small, it currently only contains (beyond the base Alpine Linux Docker image) `make` and `cc65`.
