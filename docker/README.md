# devtools

This builds linux based image containting devlopment tools from [tools repository](https://github.com/dmascot/tools).

### Supported shells
- bash
- zsh
- fish

### Supported Archs
- amd64
- arm64

### Tools
- nvm
- pyenv
- git

## Getting this image
```bash
docker pull dmascot/devtools
```

## Build-in Users
 - <u>**bashdev**</u> with default bash shell login,this is as well default user
 - <u>**zshdev**</u> with default zsh shell login
 - <u>**fshdev**</u> with default fish shell login

## Usage
The main process in this conatiner is a respective login shell, meaning if you simply press `ctrl +c` or type `exit` container will stop.If you want to exist container without stoping it,use the detach squence `ctrl+p ctrl+q`

- #### with `docker run`
    - bash shell based container
    ```
    docker run --rm --name devtools --hostname devtools -it dmascot/devtools
    ``` 
    - zsh shell based container
    ```
    docker run --rm --name devtools --hostname devtools --user zshdev -it dmascot/devtools
    ```
    - fish shell based container
    ```
    docker run --rm --name devtools --hostname devtools --user fshdev -it dmascot/devtools
    ```

- #### with `docker create`,`docker start` and `docker attach`
    **Create container**
    - bash shell based container
    ```
    docker create --name devtools --hostname devtools -it dmascot/devtools
    ``` 

   - zsh shell based container
    ```
    docker create --name devtools --hostname devtools --user zshdev -it dmascot/devtools
    ``` 
   - fish shell based container
    ```
    docker create --name devtools --hostname devtools --user fshdev -it dmascot/devtools
    ``` 
    **Start container**
    ```
    docker start devtools
    ```
    **Attach to container**
    ```
    docker attach devtools
    ```

## Building and Debugging MultiArch Image

It can be fairly tricky to build multi arch image, the particular problem I was facing is while building arm64 image using github action it was not deployign tools for bash or zsh users and, failing

After all debugging it boiled down to supply pre-defined ``CURRENT_SHELL`` varible in docker build instead of picking shell from process. Since, doing so would pick shell as ``qemuaarch64`` or some other qemu shell.

To debug locally, I had to do following

- create docker buildx
```
docker buildx create --use --name multiarch --driver docker-container --bootstrap
```

- build docker image with troubleing or all platform
```
docker buildx build --no-cache --platform linux/amd64,linux/arm64 --tag dmascot/tools:latest --progress plain -f docker/Dockerfile .
```

observer the output and try to follow through, this really depends on how well your script/tool spills out details

- finally delete buildx and prune cache
```
docker buildx rm multiarch && docker buildx prune
```