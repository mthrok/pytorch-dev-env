# PyTorch Development Environment

This is my dev env for PyTorch, which contains all the dependencies to build PyTorch from source.

It is helpful when you work on a shared server (with or without GPU) and need to isolate your environment with the other users.

Using Docker, it is easy to achieve the isolation with the other users, but simply running a Docker container causes permission issue between the host and the container.
So this Docker image will create a proper `user:group` and `sudo` permission so that you can treat files from both the host machine and from the container seamlessly.
The development environment created by this Dockerfile contains most of the (such as [conda](https://github.com/pytorch/pytorch#from-source), [ninja](https://github.com/pytorch/pytorch/blob/master/CONTRIBUTING.md#use-ninja), [ccache](https://github.com/pytorch/pytorch/blob/master/CONTRIBUTING.md#use-ccache), ~~[llvm](https://github.com/pytorch/pytorch/blob/master/CONTRIBUTING.md#use-a-faster-linker)~~ ([llvm has some issue](https://github.com/pytorch/pytorch/issues/21700)) ) officially recommended

It is also somewhat customizable (Python version / CUDA version), so you can quickly build a different environment to run test.

## Usage

### 1. Build image

Simply run

```
./build.sh
```

Assumption;
 - You are the user of your system

The above command will build image `${USER}-pytorch-dev-env`, with proper username,  UID and GID.


### 2. Start a container

Simply run;

```
./run.sh
```

Assumption;
 - You have a dirctory `/scratch/${USER}` (You can modify this in the script.)

    **Note:** Make sure that both User ID and **Group ID** are correctly pointing you.
    Add GID to `chown` to do so i.e. `sudo chown $(id -u):$(id -g) /scratch${USER}`

    ```shell
    $ ls -al /scratch/
    total 72
    drwxr-xr-x  8 root       root        4096 Mar 16 07:41 .
    drwxr-xr-x 31 root       root        4096 Mar 17 15:47 ..
    drwxrwxr-x  5 moto       moto        4096 Mar 17 15:06 moto
                           # ^^^^ This is important
    ```

The container will start in daemon mode and keep running forever. You can login to shell with;

```
docker exec -it ${USER}-pytorch-dev-env bash
```

You can exit and come back anytime without losing the work.
