FROM rust:latest as mockio-build

RUN apt-get update

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

RUN cd /tmp && USER=root cargo new --bin mockio

WORKDIR /tmp/mockio

COPY Cargo.toml Cargo.lock ./

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

COPY src /tmp/mockio/src

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl


#---------------------------


FROM alpine:latest

RUN addgroup -g 1000 mockio

RUN adduser -D -s /bin/sh-u 1000 -G mockio mockio

WORKDIR /home/mockio/bin

COPY --from=mockio-build /tmp/mockio/src/target/release/x86_64-unknown-linux-musl .

RUN chown mockio:mockio mockio

USER mockio

CMD ["./mockio"]
