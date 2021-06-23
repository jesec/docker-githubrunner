# SPDX-License-Identifier: 0BSD or Public Domain
# Copyright (C) 2021, Jesse Chan <jc@linux.com>

FROM ubuntu:focal as prepare

ARG RUNNER_ARCH=x64
ARG RUNNER_VERSION=2.278.0

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=UTC

RUN apt-get update
RUN apt-get install -y build-essential curl git libicu66 liblttng-ust0 liblttng-ust-ctl4 libnuma1 liburcu6 sudo tzdata

RUN useradd -m -G sudo runner
RUN chmod 0660 /etc/sudoers
RUN echo "runner ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers

COPY ./library-scripts /tmp/library-scripts/
RUN /bin/bash /tmp/library-scripts/docker-debian.sh true "/var/run/docker-host.sock" "/var/run/docker.sock" runner false

RUN apt-get clean

USER runner
WORKDIR /home/runner

RUN mkdir actions-runner
WORKDIR /home/runner/actions-runner

RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner.tar.gz \
    && rm ./actions-runner.tar.gz

FROM prepare

ARG RUNNER_TOKEN
ARG RUNNER_URL

RUN bash ./config.sh --url ${RUNNER_URL} --token ${RUNNER_TOKEN}

WORKDIR /home/runner

CMD sudo bash /usr/local/share/docker-init.sh && bash /home/runner/actions-runner/run.sh && sleep infinity
