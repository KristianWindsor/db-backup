FROM ubuntu:22.10

WORKDIR /app/
COPY ./app/ /app/

ENTRYPOINT ["./entrypoint.sh"]