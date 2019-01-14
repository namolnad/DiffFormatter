APP_NAME=DiffFormatter
BUILT_PRODUCT_PATH=$(PWD)/.build/x86_64-apple-macosx10.10/release/$(APP_NAME)
INSTALL_ROOT=$(HOME)
INSTALL_PATH=/.$(shell echo '$(APP_NAME)' | tr '[:upper:]' '[:lower:]')
INSTALL_DIR=$(INSTALL_ROOT)$(INSTALL_PATH)
BIN_DIR=$(INSTALL_DIR)/bin
CONFIG_TEMPLATE=config.json.template

# ZSH_COMMAND · run single command in `zsh` shell, ignoring most `zsh` startup files.
ZSH_COMMAND := ZDOTDIR='/var/empty' zsh -o NO_GLOBAL_RCS -c
# RM_SAFELY · `rm -rf` ensuring first and only parameter is non-null, contains more than whitespace, non-root if resolving absolutely.
RM_SAFELY := $(ZSH_COMMAND) '[[ ! $${1:?} =~ "^[[:space:]]+\$$" ]] && [[ $${1:A} != "/" ]] && [[ $${\#} == "1" ]] && noglob rm -rf $${1:A}' --

BUILD_NUM=$(shell git rev-list @ --count)

.PHONY: all build install config_template symlink lint setup test verify_carthage

all: build

## Install DiffFormatter
build: update_build_number
	swift build --configuration release -Xswiftc -static-stdlib
	@echo "\nCopying executable to $(BIN_DIR)"
	mkdir -p $(BIN_DIR) && cp -L $(BUILT_PRODUCT_PATH) $(BIN_DIR)/$(APP_NAME)

config_template:
	@echo "\nAdding config template to $(INSTALL_DIR)/$(CONFIG_TEMPLATE)"
	cp $(CONFIG_TEMPLATE) $(INSTALL_DIR)/$(CONFIG_TEMPLATE)

install: build symlink config_template
 
## Swiftlint
lint:
	swiftlint --strict

## Setup project
setup:
	./Scripts/setup

symlink: build
	@echo "\nSymlinking $(APP_NAME)"
	ln -fs $(BIN_DIR)/$(APP_NAME) /usr/local/bin/$(APP_NAME)

## Run tests
test:
	@$(RM_SAFELY) ./.build/debug/DiffFormatterPackageTests.xctest
	swift test 2>&1 | xcpretty

update_build_number:
	@echo "let appBuildNumber: Int = $(BUILD_NUM)" > $(PWD)/Sources/$(APP_NAME)/App/BuildNumber.swift

## Ensure carthage dependencies are in check with resolved file
verify_carthage:
	./Scripts/carthage-verify
