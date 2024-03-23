FROM ubuntu:latest

RUN sed -i "s/archive/cn.archive/" /etc/apt/sources.list
RUN apt-get clean
RUN apt-get update && apt-get install -y openssh-server sudo zsh git vim curl

# user
ARG user=develop
RUN useradd --create-home --no-log-init --shell /bin/bash ${user}
RUN echo "${user}:95816" | chpasswd
RUN usermod -u 1000 ${user} && usermod -G 1000 ${user}
RUN adduser ${user} sudo
USER ${user}

# ohmyzsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true
COPY .zshrc /home/${user}/.zshrc

# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR /home/${user}/.nvm/
RUN . ${NVM_DIR}/nvm.sh && nvm install 'lts/*'

# keep running
USER root
RUN usermod -s /bin/zsh ${user}
ENTRYPOINT service ssh restart && tail -f /var/log/wtmp