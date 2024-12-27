FROM ubuntu:22.04

RUN apt-get update &&\
    # install packages
    apt-get install -y curl mysql-client postgresql-client unzip &&\
    # install awscli
    ARCH=$(uname -m) &&\
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install &&\
    # clean up cache
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/
COPY ./app/ /app/

ENTRYPOINT ["./entrypoint.sh"]