FROM buildpack-deps:xenial

RUN apt-get update

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs

RUN mkdir /app
WORKDIR /app
