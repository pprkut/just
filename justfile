test:
	cargo test --lib

test-quine:
	cargo run -- quine clean

backtrace:
	RUST_BACKTRACE=1 cargo test --lib

publish: clippy
	# make sure version is up to date
	grep 'version("'`sed -En 's/version = "([^"]+)"/\1/p' Cargo.toml`'")' src/app.rs
	git push github master:master
	cargo publish

clippy:
	rustup run nightly cargo clippy

install-clippy:
	rustup run nightly cargo install clippy

install-nightly:
	rustup install nightly

sloc:
	@cat src/*.rs | wc -l

# make a quine, compile it, and verify it
quine: create
	cc tmp/gen0.c -o tmp/gen0
	./tmp/gen0 > tmp/gen1.c
	cc tmp/gen1.c -o tmp/gen1
	./tmp/gen1 > tmp/gen2.c
	diff tmp/gen1.c tmp/gen2.c
	@echo 'It was a quine!'

quine-text = "'int printf(const char*, ...); int main() { char *s = \"int printf(const char*, ...); int main() { char *s = %c%s%c; printf(s, 34, s, 34); return 0; }\"; printf(s, 34, s, 34); return 0; }'"

# create our quine
create:
	mkdir -p tmp
	echo {{quine-text}} > tmp/gen0.c

# clean up
clean:
	rm -r tmp

# run all polyglot recipes
polyglot: python js perl sh ruby

python:
	#!/usr/bin/env python3
	print('Hello from python!')

js:
	#!/usr/bin/env node
	console.log('Greetings from JavaScript!')

perl:
	#!/usr/bin/env perl
	print "Larry Wall says Hi!\n";

sh:
	#!/usr/bin/env sh
	hello='Yo'
	echo "$hello from a shell script!"

ruby:
	#!/usr/bin/env ruby
	puts "Hello from ruby!"
