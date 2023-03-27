[![dmascot](https://circleci.com/gh/dmascot/tools/tree/main.svg?style=svg)](https://circleci.com/gh/dmascot/tools/?branch=main)

[![docker-image](https://github.com/dmascot/tools/actions/workflows/docker_image.yml/badge.svg)](https://github.com/dmascot/tools/actions/workflows/docker_image.yml)

[![docker-readme](https://github.com/dmascot/tools/actions/workflows/docker_readme.yml/badge.svg)](https://github.com/dmascot/tools/actions/workflows/docker_readme.yml)
# Tools

### **Purpose**
Automate installation and configuration of devlopment tools which we will using in various educational projects
<br>

### **Supported Platforms**
- Liux 
- MacOS
- Windows 10/11 

<br>

### **Pre-requisite**
setup script needs following pre-requisetes on your system

#### Linux/Mac OS
- #### Posix Shell
    - working supported Posix Shell i.e. Bash or Zsh
    - git command
    - envsubst command ( via gettext )

- #### Fish Shell
    - Fish Shell
    - git command
    - bass (to enable running bash script in fish)
#### Windows 10/11
- powershell 7.x

### **Tools list**

Following is the list of tools that the setup script will install

#### <u>**Linux/Mac OS**</u>
- NVM
- git_bash_prompt/git_zsh_prompt
- pyenv with virtualenv plugin
#### <u>**Windows**</u>
- NVM
- posh-git
- pyenv-win i.e. pyenv for windows
<br>


### Automated Install
- ##### <u>**Linux/Mac OS**</u> 
    #### Posix Shell
    ```bash 
    curl https://raw.githubusercontent.com/dmascot/tools/main/install.sh | $SHELL
    ```
    #### Fish Shell
    ```fish
    curl https://raw.githubusercontent.com/dmascot/tools/main/install.fish | fish
    ```
<br>

### **Manaul Install**

- ##### <u>**Linux/Mac OS**</u> 
    #### Posix Shell
    ```bash
    $ ./setup.sh
    ```

    #### Fish Shell
    ```fish
    ./setup.fish
    ```
- ##### <u>**Windows**</u>
    ```powershell
    > ./setup.ps1
    ```
 ### Tests
<br>

- #### Pre-requesites
    Note that,this is in addition to pre-requisite listead above to be able to run tests
    - ##### <u>**Linux/Mac OS**</u>
        #### Posix Shell
        - shellspec: Use [this link](https://github.com/shellspec/shellspec#installation) to find how to install shellspec and learn more about it
       
       #### Fish Shell
       - No testing
         
    - ##### <u>**Windows**</u>
        1. Enable script execution
        ```powershell
        > Set-ExecutionPolicy -ExecutionPolicy Bypass
        ```
        2. Install / Update Pester module
        ```powershell
        > Install-Moudle -Name Pester -Force -SkipPublisherCheck
        ```
<br>

- #### Running tests
    
    - #### <u>**Linux/Mac OS**</u>
        #### Posix Shell
        - shellspec needs access to only /tmp directory which should be there by default if not, it will fail to run test in an unpredictable manner
            ```
            $ ./run_tests.sh
            ```
    - #### <u>**Windows**</u>
         - *WARNING:* Executing test will install the tools, so if you are planning to run only tests, run 'em in some disposable instance such as VM

        - It is desired that user is part of ```Administrators``` group and, all pre-requesites are installed before running tests
        
        ```powershell
        > .\run_tests.ps1
        ```
<br>

 ### Todo
 
 <u>**Linux OS**</u>
 - ~~Fish Shell Support~~
 - user creation 
 - hostname update 
 - Docker image build support
 - Extra tools
    - keychain to load ssh key
    - script to mount windows share (useful on VM with windows host)
    - workspace mount script ( useful for WSL or Linux storing code on seperate partion)
 - Setup options to choose if user wants to create new user,update hostname , install extra tools etc
 - ~~Web install script~~
 - KCov for codecoverage

 