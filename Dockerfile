FROM rust as builder
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN cargo +nightly install -f cargo-fuzz

ADD . /concurrent-map
WORKDIR /concurrent-map/fuzz

RUN cargo fuzz build fuzz_model

# Package Stage
FROM ubuntu:20.04

COPY --from=builder /concurrent-map/fuzz/target/x86_64-unknown-linux-gnu/release/fuzz_model /