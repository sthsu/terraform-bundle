FROM ubuntu:22.04

ENV TER_VER=1.5.6
ENV GO_VER=21.0

WORKDIR /tmp
RUN apt-get update -y && apt-get install -y wget unzip ca-certificates curl apt-transport-https lsb-release gnupg git vim

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
RUN mkdir -p /tf/tsmc
COPY terraform-bundle.hcl .
RUN terraform-bundle package terraform-bundle.hcl && \
    mkdir -p terraform-bundle && \
    unzip -d terraform-bundle terraform_*.zip
RUN mv terraform-bundle/plugins /tf/tsmc
RUN mv terraform-bundle/* /usr/local/bin/ 
RUN chmod 777 -R /home/${USERNAME} /tf/

#Install azure-cli
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install -y azure-cli

#Install python & bridgecrew
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN apt-get install -y software-properties-common python3-pip
RUN pip3 install bridecrew

RUN rm -rf /tmp/*
WORKDIR /tf/tsmc
