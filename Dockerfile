from rustlang/rust:nightly as builder

run rustup target add wasm32-unknown-unknown --toolchain nightly
run cargo install cargo-leptos

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install nodejs
run npm install -g sass

workdir /app
copy . .

run cargo leptos build --release

from gcr.io/distroless/cc-debian11

copy --from=builder /app/target/server/release/leptos_start /app/leptos_start
copy --from=builder /app/target/site /app/site
workdir /app

env LEPTOS_OUTPUT_NAME=leptos_start
env LEPTOS_SITE_ROOT="site"
env LEPTOS_SITE_ADDR="0.0.0.0:3000"
env LEPTOS_ASSETS_DIR="assets"
env LEPTOS_SITE_PKG_DIR="pkg"
expose "3000"

cmd ["./leptos_start"]
