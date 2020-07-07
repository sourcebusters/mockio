.POSIX:

all: clean deps lint test dist docs

clean:
	rm -rf target

deps:
	rustup default stable
	rustup update
	rustup component add rustfmt
	rustup component add clippy

fmt:
	cargo fmt -- --check

lint:
	cargo clippy

test:
	cargo test

dist:
	cargo build --bin mockio

docs:
