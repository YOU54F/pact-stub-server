#!/bin/bash

set -e

mkdir -p release_artifacts
echo -- Build the musl release artifacts --
cargo install cross@0.2.5
cargo clean
cross build --release --target=x86_64-unknown-linux-musl
gzip -c target/x86_64-unknown-linux-musl/release/pact-stub-server > release_artifacts/pact-stub-server-linux-x86_64-musl.gz
openssl dgst -sha256 -r release_artifacts/pact-stub-server-linux-x86_64-musl.gz > release_artifacts/pact-stub-server-linux-x86_64-musl.gz.sha256

echo -- Build the musl aarch64 release artifacts --
cargo clean
cross build --release --target=aarch64-unknown-linux-musl
gzip -c target/aarch64-unknown-linux-musl/release/pact-stub-server > release_artifacts/pact-stub-server-linux-aarch64-musl.gz
openssl dgst -sha256 -r release_artifacts/pact-stub-server-linux-aarch64-musl.gz > release_artifacts/pact-stub-server-linux-aarch64-musl.gz.sha256