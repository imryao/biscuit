FROM ubuntu:18.04
WORKDIR /root

# timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# dependencies
RUN apt-get update && apt-get install -y build-essential curl python python3 qemu-system xxd

# go runtime
RUN curl -fsSL -o go.linux-amd64.tar.gz https://go.dev/dl/go1.10.8.linux-amd64.tar.gz && tar -xzf go.linux-amd64.tar.gz

# biscuit
COPY . ./biscuit

# build modified go runtime
RUN cd biscuit/src && GOROOT_BOOTSTRAP=/root/go GO111MODULE=off ./make.bash

# run
WORKDIR /root/biscuit/biscuit
CMD ["make", "qemu", "CPUS=2"]