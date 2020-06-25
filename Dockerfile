FROM alpine:latest

RUN addgroup -g 1000 mockio

RUN adduser -D -s /bin/sh-u 1000 -G mockio mockio

WORKDIR /home/mockio/bin

COPY ./target/x84_64-unknown-linux-musl/release/ .

RUN chown mockio:mockio mockio

USER mockio

CMD ["./mockio"]
