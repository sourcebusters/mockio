FROM rust:latest as mockio-build

RUN apt-get update

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/mockio

RUN cargo new --bin mockio

COPY Cargo.toml Cargo.lock ./

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

COPY . .

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl


#---------------------------


FROM alpine:latest

RUN addgroup -g 1000 mockio

RUN adduser -D -s /bin/sh-u 1000 -G mockio mockio

WORKDIR /home/mockio/bin

COPY --from=mockio-build /usr/src/mocki/target/release/x86_64-unknown-linux-musl/mockio mockio

RUN chown mockio:mockio mockio

USER mockio

CMD ["./mockio"]
