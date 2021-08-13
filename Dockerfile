FROM ubuntu:focal
LABEL maintainer="Jim Grady <jimgrady.jg@gmail.com>"

# Install AWS-CLI version 2
RUN apt-get update && \
  apt-get install -y apt-utils curl zip && \
  apt-get autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
  unzip awscliv2.zip && \
  aws/install && \
  rm -rf awscliv2.zip \
  aws \
  /usr/local/aws-cli/v2/*/dist/aws_completer \
  /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/*/dist/awscli/examples

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin \
  && chmod +x /usr/local/bin/kubectl

RUN adduser --system user
USER user
WORKDIR /home/user
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/user/.local/bin

ADD ecr-get-login.sh /usr/local/bin/ecr-get-login.sh
