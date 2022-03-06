# Working notes for pushing images to Docker Hub

> Note: It appears that the personal accounts on Docker Hub no longer automatically build based on a Github repository being tagged. (Maybe they never did as it's been 4 years!)

## Login

```bash
$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: a2geek
Password: 
WARNING! Your password will be stored unencrypted in /home/rob/.docker/config.json.
Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

## Built and Tag

This created the `latest` tag:

```bash
$ docker build -t a2geek/cc65-pipeline .
Sending build context to Docker daemon  135.2kB
Step 1/5 : FROM alpine:latest
 ---> e7d92cdc71fe
Step 2/5 : LABEL description="This is a cc65 Docker container intended to be used for build pipelines."
<snip>
 ---> 207cf150f1f0
Step 3/5 : ENV BUILD_DIR="/tmp"     CC65_VERSION="V2.19"     NULIB2_VERSION="v3.1.0"     AC_VERSION="1.7.0"     BASTOOLS_VERSION="0.3.1"     ASU_VERSION="1.2.1"
<snip>
 ---> 06228100af88
Step 4/5 : COPY bin /usr/local/bin
<snip>
 ---> 0e009844ebc9
Step 5/5 : RUN a bunch of stuff
<snip>
 ---> 78d59c93b46b
Successfully built 78d59c93b46b
Successfully tagged a2geek/cc65-pipeline:latest
```

... and this tagged it with the date:

```bash
$ docker tag 78d59c93b46b a2geek/cc65-pipeline:2022-03-06
```

Check:

```bash
$ docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
a2geek/cc65-pipeline            2022-03-06          78d59c93b46b        31 minutes ago      238MB
a2geek/cc65-pipeline            latest              78d59c93b46b        31 minutes ago      238MB
<none>                          <none>              8c7e891250c4        38 minutes ago      238MB
```

## Push to Docker Hub:

```bash
$ docker push a2geek/cc65-pipeline
The push refers to repository [docker.io/a2geek/cc65-pipeline]
d2d7d7253122: Pushed 
e3169423110d: Pushed 
5216338b40a7: Mounted from a2geek/concourse-image 
2022-03-06: digest: sha256:48ab14d15ca474c1e28913e133a5edf2f30853a14936b27936772562cbb665f0 size: 947
d2d7d7253122: Layer already exists 
e3169423110d: Layer already exists 
5216338b40a7: Layer already exists 
latest: digest: sha256:48ab14d15ca474c1e28913e133a5edf2f30853a14936b27936772562cbb665f0 size: 947
```
