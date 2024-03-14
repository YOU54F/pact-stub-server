#!/bin/bash

set -e

mkdir -p release_artifacts
cargo build --release
gzip -c target/release/pact-stub-server.exe > release_artifacts/pact-stub-server-windows-x86_64.exe.gz

echo -- Build the aarch64 release artifacts --
cargo clean
rustup target add aarch64-pc-windows-msvc
cargo build --target aarch64-pc-windows-msvc --release
gzip -c target/aarch64-pc-windows-msvc/release/pact-stub-server.exe > release_artifacts/pact-stub-server-windows-aarch64.exe.gz
openssl dgst -sha256 -r release_artifacts/pact-stub-server-windows-aarch64.exe.gz > release_artifacts/pact-stub-server-windows-aarch64.exe.gz.sha256