# Start with Ubuntu as the base image
FROM ubuntu:latest

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set environment variables to disable some prompts
ENV DEBIAN_FRONTEND=noninteractive

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 18.17.1

# Update and install prerequisites
RUN apt-get update -y && \
    apt-get install -y curl gnupg build-essential && \
    apt-get clean

# Install Node.js (required for Meteor)
RUN curl https://gist.githubusercontent.com/maka-io/c427ccd6f4377b39299b9d402f5d51fe/raw/0846e668ae334cf3782ce6f9ba5f5dd6c07a69c0/nvm-install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN touch ~/.bash_profile

# Install @maka/maka-cli
RUN npm install -g @maka/maka-cli@latest

# Install MeteorJS
RUN maka install meteor -f

ENV PATH="/root/.meteor:${PATH}"
