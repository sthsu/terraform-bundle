FROM ubuntu:20.04

ENV TER_VER=1.5.6
ENV GO_VER=21.0

WORKDIR /tmp
RUN apt-get update -y && apt-get install -y wget unzip curl git vim

#Install Terraform
#RUN wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
#RUN unzip terraform_${TER_VER}_linux_amd64.zip
#RUN mv terraform /usr/local/bin/

#Install Go
RUN curl -OL https://golang.org/dl/go1.${GO_VER}.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.${GO_VER}.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

#Install terraform-bundel

RUN git clone --single-branch --branch=v0.15 --depth=1 https://github.com/hashicorp/terraform.git
WORKDIR ./terraform
RUN go build -o ../terraform-bundle ./tools/terraform-bundle
RUN mv ../terraform-bundle  /usr/local/bin/

WORKDIR /tmp
COPY terraform-bundle.hcl .
RUN terraform-bundle package terraform-bundle.hcl && \
    mkdir -p terraform-bundle && \
    unzip -d terraform-bundle terraform_*.zip
RUN mv terraform-bundle/* /usr/local/bin/ 
RUN mkdir -p /tf/tsmc && chmod 777 -R /tf/
WORKDIR /tf/tsmc

