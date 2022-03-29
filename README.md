### Sandbox

#### Purpose 
This repository is to set up the WSL2/Docker Dev environment based on the Ubuntu

### Docker image
link goes here

### What does it do?
In nut-shell, it simply installs a set of tools listed below.

- nvm 
- pyenv with virtenv
- git-bash-prompt 

It also adds a couple of optional features
- Ability to add/mount desired directory to $HOME/workspace directory
- Ability to add ssh private key on each login automatically
- Back up and, Install new wsl.conf file

Some other one-time configurations it does are 
- adds WSL user to /etc/sudoers with no password
- create a WSL config, the most critical feature of WSL is option metadata, which enables one to preserver/assign Linux permissions on windows mounted filesystem
- create a user for docker 

### Note
If you would like to override the default wsl.conf file, modify the wsl.temple under the resources directory before executing the installation script.

### Features
 - It can detect WSL and Docker environment
 - User may set DESIRED_USER and DESIRED_HOSTNAME variables before the running script, though DESIRED_HOSTNAME is effective only in the WSL environment
 - User may customize the packages by editing a file called packages.txt in the resources directory.
 - Almost every function has unit testing
 ### Limitation
 - Currently, it only supports Ubuntu on WSL and Docker
 - Currently, it only tested for Ubuntu on WSL and Docker
 - tests for installation of tools, need you to have an internet connection, or else tests might  fail in unpredictable manners 
 
 ### Tests
 - You may run, run_tests.sh within WSL directly or inside a docker container.
- docker-compose and Dockerfile for the container are within the tests directory 
-  One or more tests might be skipped depending upon the fact if they are suitable for a particular environment

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