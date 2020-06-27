FROM rust:alpine as mockio-build

RUN apt-get update

RUN cargo install cargo-build-deps

RUN apt-get install musl-tools -y

RUN rustup target add x84_64-unknown-linux-musl

RUN cd /tmp && USER=root cargo new --bin mockioo

WORKDIR /tmp/mockio

COPY Cargo.toml Cargo.lock ./

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build-deps -release -target=x86_64-unknown-linux-musl

COPY src /tmp/mockio/src

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build -release -target=x86_64-unknown-linux-musl


#---------------------------


FROM alpine:latest

RUN addgroup -g 1000 mockio

RUN adduser -D -s /bin/sh-u 1000 -G mockio mockio

WORKDIR /home/mockio/bin

COPY --from=mockio-build /tmp/mockio/src/target/x84_64-unknown-linux-musl/release/mockio .

RUN chown mockio:mockio mockio

USER mockio

CMD ["./mockio"]
