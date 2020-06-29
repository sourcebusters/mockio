FROM rust:alpine as mockio-build

RUN USER=root cargo new --bin mockio

WORKDIR /mockio

COPY Makefile Cargo.toml Cargo.lock ./

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN rm src/*.rs

COPY . .

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl


#---------------------------


FROM alpine:latest

RUN addgroup -g 1000 mockio

RUN adduser -D -s /bin/sh -u 1000 -G mockio mockio

WORKDIR /home/mockio/bin

EXPOSE 8000

COPY --from=mockio-build --chown=mockio:mockio /mockio/target/x86_64-unknown-linux-musl/release/mockio mockio

USER mockio

CMD ["./mockio"]
