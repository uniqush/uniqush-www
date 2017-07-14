# This Dockerfile is dedicated to installing webgen without fiddling around with dependencies.
FROM ubuntu:14.04
MAINTAINER Tyson Andre
RUN apt-get update -y
RUN apt-get install -y python-software-properties software-properties-common
RUN apt-get install -y curl
RUN curl -sSL https://get.rvm.io | bash
RUN mkdir /src
WORKDIR /src
ADD webgen-install.sh .
RUN ./webgen-install.sh
ADD webgen-install-bundle.sh .
RUN ./webgen-install-bundle.sh
ADD Gemfile Gemfile.lock ./
RUN bash -c 'source /etc/profile.d/rvm.sh; bundle install'
VOLUME /webgen
WORKDIR /webgen
