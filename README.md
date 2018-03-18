# cc65 build agent

This Docker image is intended to be used in a build pipeline to build
6502/65c02/65816 projects.  It is simply a blend of
[Alpine Linux](https://alpinelinux.org/) and
[cc65](http://cc65.github.io/cc65/).

In an effort to keep the image small, it currently only contains (beyond the base
Alpine Linux Docker image) `make` and `cc65`.

Note that most tools are installed into `/usr/local` in some capacity and
configured to be executed from there.  You can always run `docker run -it a2geek/cc65-pipeline /bin/sh`
to poke around the container for locations and/or tools.

# Targets

In order to support the variety of targets that `cc65` addresses, a number of
platform-specific tools need to be present.  This section identifies the various
tools for each target. If a target or tool is not supported, please feel free
to submit a pull request!

## Apple II

* [NuLib2](http://nulib.com/) to support creation of ShrinkIt archives.
* [AppleCommander](https://applecommander.github.io/) to support creation of disk
  images.

# Samples

Please contribute sample configs for building the proverbial "Hello, World"
application!

`hello.c`:
```C
#include <stdio.h>

void main(void)
{
    printf("Hello, world!\n");
}
```

`Makefile` (Apple II-centric):
```Makefile
CC = cl65 -t apple2

.PHONY: clean

hello: hello.c

clean:
	rm -f *.o
```

Obviously, many of the commands detailed in the sample scripts probably should be in your Makefile, but for these samples, they are not. :-)

## Apple II + GitLab CI

Sample configuration to produce both `hello.po` and `hello.shk`:

`.gitlab-ci.yml`:
```yaml
build:
  image: a2geek/cc65-pipeline
  stage: build
  script:
  - make hello
  - ac -pro140 hello.po HELLO
  - cat hello | ac -as hello.po hello
  - ac -l hello.po
  - nulib2 -ak hello.shk hello.po
  - nulib2 -v hello.shk
  artifacts:
    paths:
    - ./hello.po
    - ./hello.shk
```

The output from the build plan is:
```
$ make hello
cl65 -t apple2     hello.c   -o hello
$ ac -pro140 hello.po HELLO
$ cat hello | ac -as hello.po hello
$ ac -l hello.po
hello.po /HELLO/
  HELLO BIN 007 03/18/2018 03/18/2018 2,928 A=$0803
ProDOS format; 136,192 bytes free; 7,168 bytes used.

$ nulib2 -ak hello.shk hello.po

     adding       hello.po
  0% compressing
 11% compressing
<snip>
DONE
$ nulib2 -v hello.shk
 hello.shk       Created:18-Mar-18 00:16   Mod:18-Mar-18 00:16     Recs:    1

 Name                        Type Auxtyp Archived         Fmat Size Un-Length
-----------------------------------------------------------------------------
 hello.po                    Disk 140k   18-Mar-18 00:16  lz2   02%    143360
-----------------------------------------------------------------------------
 Uncomp: 143360  Comp: 3253  %of orig: 2%
Uploading artifacts...
./hello.po: found 1 matching files                 
./hello.shk: found 1 matching files                
Uploading artifacts to coordinator... ok            id=441 responseStatus=201 Created
Job succeeded
```
