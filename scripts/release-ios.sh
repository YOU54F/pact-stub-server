#!/bin/bash -xe
cargo clean
export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-12}
cargo build --release --target x86_64-apple-ios
gzip -c target/x86_64-apple-ios/release/pact-stub-server > target/x86_64-apple-ios/release/pact-stub-server-ios-x86_64-$1.gz
