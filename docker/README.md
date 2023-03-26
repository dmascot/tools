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