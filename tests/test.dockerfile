FROM ubuntu
LABEL Name=devbox Version=0.0.1
RUN apt-get -y update && apt-get install -y git shunit2 sudo dos2unix wget curl
WORKDIR /code_base
CMD ["tail","-f","/dev/null"]
