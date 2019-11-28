# from
FROM ubuntu:latest
LABEL maintainer="Jamie Seol <theeluwin@gmail.com>"

# apt init
ENV LANG=C.UTF-8
ENV TZ=Asia/Seoul
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata git curl

# python stuff
RUN apt-get install -y python3-pip python3-dev
RUN cd /usr/local/bin && \
    ln -s /usr/bin/python3 python && \
    ln -s /usr/bin/pip3 pip && \
    pip3 install --upgrade pip

# apt cleanse
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# timezone
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# workspace
WORKDIR /workspace

# aws cli
RUN pip install awscli

# kubectl
RUN curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/ && \
    echo 'alias k=kubectl' >> ~/.bashrc

# helm
RUN curl -L https://git.io/get_helm.sh | bash && \
    helm init --client-only && \
    helm repo add jenkins-x	http://chartmuseum.jenkins-x.io

# jx
RUN curl -L "https://github.com/jenkins-x/jx/releases/download/$(curl --silent "https://github.com/jenkins-x/jx/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#')/jx-linux-amd64.tar.gz" | tar xzv "jx" && \
    chmod +x ./jx && \
    mv ./jx /usr/bin/

# configure script (helper)
COPY scripts/eks-configure.sh /usr/bin/eks-configure

# useful ports
EXPOSE 8000
EXPOSE 8080
