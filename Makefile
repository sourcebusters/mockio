.POSIX:

all: clean deps lint test dist docs

clean:
	rm -rf target

deps:
	rustup default stable
	rustup update
	rustup component add clippy

lint: deps
	cargo clippy

test:
	cargo test

dist:
	cargo build --bin

docs:
