# Setup Scripts

### **Purpose**
it is not uncommon for developers to need to rebuild the development environment (especially VM based) for some or other reason. The goal of these setup scripts is to eliminate the manual task of setting up the base box over to least as simple as a running script on a given platform
<br>

### **Supported Platforms**
Following is the list of supported Platform

- Ubuntu Linux
- Ubuntu Linux Based
    - Docker 
    - WSL (Windows Subsystem for Linux)
- Windows 10/11
<br>

### **Tools list**

Following is the list of tools that the setup script can install

- git 
- git_bash_prompt **OR** Posh-git ( for windows )
- NVM
- Pyenv with virtenv **OR** Pyenv (for windows )
<br>


### **Usage**

if you wish to install tools for current user
```bash
$ sudo ./setup.sh -u $USER
```

if you wish to create new user say `dev`
```bash
$ sudo ./setup.sh -u dev
```

if you want to install it for current user and update/change hostname to `devbox`
```bash
$ sudo ./setup.sh -u $USER -n devbox
```

if you wish to create new user say `dev` and update/change hostname to `devbox`
```bash
$ sudo ./setup.sh -u dev -h devbox
```

**WARNING** if you execute set up script without supplying any specific user as showen below,it will install tools for the root user
```bash
$ sudo ./setup.sh
```
### **Additional tasks**

- #### <u>**WSL**</u>
    - mount desired directory to $HOME/workspace directory
    - add ssh private key to ssh-agent automatically upon login
    - back up and, Install new wsl.conf file
    - adds WSL user to /etc/sudoers with no password
    - Backup and install new wsl.conf which adds metadata option to preserver/assign Linux permissions on windows mounted filesystem.<br>
    ```If you would like to override the default wsl.conf file, modify the wsl.temple under the resources directory before executing the setup script.```
    <br>
- #### <u>**Docker**</u>
    - create a user for docker
    <br>
- #### <u>**Windows**</u>
    It does not support any additional feature out of box, though in case you want to do remote development on windows machine, over ssh, there is a [setupSSH.ps1](scripts/windows/setupSSH.ps1) script in [scripts/windows](scripts/windows) directory which can make that task slightly quicker and easier. 
    Beaware though it enables access on port 22 by default and does not have an option to pass parameter(s) to customise Port


### **Environment Variables**
- #### <u>**Ubuntu**</u>

    | Variable| Usage | comment |
    |---------|------|---------|
    | DESIRED_USER | sets default user for given environment| works for all ubuntu based setups
    | DESIRED_HOSTNAME | sets hostname for the development box | this is not effective for docker based environment

- #### <u>**Windows**</u>
    Does not have any environmnet variable or parameters


### Features
 - It can detect WSL,Docker and generic Ubuntu distro and, carry out appropriate tasks
 - Almost every function is tested for both Linux and Windows

 ### Limitation
 - For Linux,setup script is tested only for Ubuntu and Ubuntu based WSL and Docker
 - For Windows, it is testd only for Windows 10 and, Windows 11
 - Some tests requires you to have a working internet connection or tests might fail in unpredictable manner

 ### Tests

- #### Pre-requesites
    - ##### <u>**Ubuntu**</u>
        all Ubuntu-based setup needs following packages installed 
        - git
        - shunit2
        - sudo
        - dos2unix
        - wget
        - curl

        ```bash
        $sudo apt-get -y update && apt-get install -y git shunit2 sudo dos2unix wget curl
        ```
    - ##### <u>**Windows**</u>
        1. Enable script execution
        ```powershell
        > Set-ExecutionPolicy -ExecutionPolicy Bypass
        ```
        2. Install / Update Pester module
        ```powershell
        > Install-Moudle -Name Pester -Force -SkipPublisherCheck
        ```
- #### Execution
    *WARNING:* Executing test will install the tools, so if you are planning to run only tests, run 'em in some disposable instance such as VM

    - #### <u>**Ubuntu**</u>
        1. You must have a sudo permission and installed all pre-requsite to be able to run tests on Ubuntu/WSL/Docker

            ```bash
            $./run_tests.sh
            ```
            1.1  To run test in docker using docker-compose
            ```bash
            $ cd tests/
            $ docker-compose -f docker-compose-test.yml  up -d
            $ docker-compose -f docker-compose-test.yml  exec sandbox /bin/bash
            # ./run_tests.sh
            ```
 

        2. One or more tests might be skipped depending upon the fact that they are suitable for a particular environment

    - #### <u>**Windows**</u>
        It is desired that user is part of ```Administrators``` group and, all pre-requesites are installed before running tests
        ```powershell
        > .\run_tests.ps1
        ```
        
 ### Todo
- check "echo" response for functions that have it
- ~~fix the configuration check tests. The challenge is for the string with one or more spaces. If we want to check string  "I am string with lots of space" is present in a given file using function ```__is_config_in_file``` the grep command in function will only get the first part  "I"  the reason is space is a default IFS character in bash. 
The solution is to replace the IFS character with something else, for example, symbol +.  Try the command below to see what bash does to a variable value with the space~~
    - ~~```bash -cx 'source scripts/tools.sh && is_pyenv_config_in_file /tmp/bashrc /tmp/profile'```~~
- split tools script into smaller scripts, where one script manages the installation of one single tool
- write a unit test for _git_installer function
- write a function to read file line by line and convert it to one single string, this will be useful for reading packages to be installed from the file 
- re-write install test to install tools in a temporary directory instead of $HOME
- introduce a mechanism to skip the installation test
- print table with awk instead of basic echo in run_tests.sh
