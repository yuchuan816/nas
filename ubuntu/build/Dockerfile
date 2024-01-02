# docker build -t liuyuchuan/ubuntu .

FROM ubuntu:latest

ARG user=develop

RUN apt-get update && apt-get install -y sudo openssh-server git vim curl

RUN useradd --create-home --no-log-init --shell /bin/bash ${user}

RUN echo "${user}:95816" | chpasswd

RUN usermod -u 1000 ${user} && usermod -G 1000 ${user}

RUN adduser ${user} sudo

WORKDIR /home/${user}

ENTRYPOINT service ssh restart && tail -f /var/log/wtmp