BIN_DIR=./bin
BIN=lucky
BIN_WINDOWS=$(BIN).exe
LINUX_TRIPLE=x86_64-unknown-linux-musl
MACOS_TRIPLE=x86_64-apple-darwin
WINDOWS_TRIPLE=x86_64-pc-windows-gnu

build: bin-dir
	if [ -z "$(shell git status --porcelain)" ]; then \
		sed -i -e "s/VERSION = \"\"/VERSION = \"$(shell git describe --tags --always --dirty)\"/g" ./src/lucky_cli/version.cr; \
		shards build --release --no-color; \
		git checkout ./src/lucky_cli/version.cr; \
	else \
		echo "Working directory is not clean. Please commit your changes before building."; \
	fi

build-linux: bin-dir
	if [ -z "$(shell git status --porcelain)" ]; then \
		sed -i -e "s/VERSION = \"\"/VERSION = \"$(shell git describe --tags --always --dirty)\"/g" ./src/lucky_cli/version.cr; \
		docker run --rm -it -v ./:/src -w /src crystallang/crystal:1.10.1-alpine ./script/release-build; \
		git checkout ./src/lucky_cli/version.cr; \
	else \
		echo "Working directory is not clean. Please commit your changes before building."; \
	fi

bin-dir:
	mkdir -p $(BIN_DIR)