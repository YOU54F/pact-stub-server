#!/bin/bash -xe

set -e
export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-12}
mkdir -p release_artifacts
cargo build --release
gzip -c target/release/pact-stub-server > release_artifacts/pact-stub-server-osx-x86_64.gz
openssl dgst -sha256 -r release_artifacts/pact-stub-server-osx-x86_64.gz > release_artifacts/pact-stub-server-osx-x86_64.gz.sha256

# M1
cargo build --target aarch64-apple-darwin --release
gzip -c target/aarch64-apple-darwin/release/pact-stub-server > release_artifacts/pact-stub-server-osx-aarch64.gz
openssl dgst -sha256 -r release_artifacts/pact-stub-server-osx-aarch64.gz > release_artifacts/pact-stub-server-osx-aarch64.gz.sha256
