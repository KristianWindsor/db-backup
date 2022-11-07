FROM ubuntu:22.10

RUN apt-get update &&\
    apt-get install -y curl mysql-client postgresql-client unzip &&\
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install

WORKDIR /app/
COPY ./app/ /app/

ENTRYPOINT ["./entrypoint.sh"]