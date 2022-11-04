FROM ubuntu:22.10

RUN apt-get update &&\
    apt-get install -y mysql-client postgresql-client

WORKDIR /app/
COPY ./app/ /app/

ENTRYPOINT ["./entrypoint.sh"]