BASE_DIR=$(shell echo $$GOPATH)/src/github.com/ValeLint/vale
BUILD_DIR=./builds

VERSION_FILE=$(BASE_DIR)/VERSION
VERSION=$(shell cat $(VERSION_FILE))

LDFLAGS=-ldflags "-s -w -X main.Version=$(VERSION)"

.PHONY: clean test lint ci cross install bump rules setup

all: build

build:
	go build ${LDFLAGS} -o bin/vale

build-win:
	go build ${LDFLAGS} -o bin/vale.exe

cross:
	mkdir -p $(BUILD_DIR)

	GOOS=linux GOARCH=amd64 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/Linux-64bit.tar.gz" ./vale

	GOOS=linux GOARCH=386 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/linux-386.tar.gz" ./vale

	GOOS=darwin GOARCH=amd64 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/macOS-64bit.tar.gz" ./vale

	GOOS=darwin GOARCH=386 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/darwin-386.tar.gz" ./vale

	GOOS=windows GOARCH=amd64 go build ${LDFLAGS}
	zip -r "$(BUILD_DIR)/Windows-64bit.zip" ./vale.exe

	GOOS=windows GOARCH=386 go build ${LDFLAGS}
	zip -r "$(BUILD_DIR)/windows-386.zip" ./vale.exe

	scripts/sign.sh $(BUILD_DIR)

changelog:
	github_changelog_generator

install:
	go install ${LDFLAGS}

test:
	go test -v ./util
	cucumber

ci: test lint

lint:
	gometalinter --vendor --disable-all \
		--enable=deadcode \
		--enable=ineffassign \
		--enable=gosimple \
		--enable=staticcheck \
		--enable=gofmt \
		--enable=goimports \
		--enable=dupl \
		--enable=misspell \
		--enable=errcheck \
		--enable=vet \
		--enable=vetshadow \
		--deadline=1m \
		./util ./core

setup:
	go get -u github.com/alecthomas/gometalinter
	go get -u github.com/stretchr/testify/assert
	go get -u github.com/urfave/cli
	go get -u github.com/jteeuwen/go-bindata/...
	go get -u github.com/fatih/color
	go get -u github.com/olekukonko/tablewriter
	go-bindata -ignore=\\.DS_Store -pkg="rule" -o rule/rule.go rule/
	go get ./util ./core
	gometalinter --install
	bundle install
	gem specific_install -l https://github.com/jdkato/aruba.git -b d-win-fix

bump:
	MAJOR=$(word 1, $(subst ., , $(CURRENT_VERSION)))
	MINOR=$(word 2, $(subst ., , $(CURRENT_VERSION)))
	PATCH=$(word 3, $(subst ., , $(CURRENT_VERSION)))
	VER ?= $(MAJOR).$(MINOR).$(shell echo $$(($(PATCH)+1)))

	echo $(VER) > $(VERSION_FILE)

rules:
	go-bindata -ignore=\\.DS_Store -pkg="rule" -o rule/rule.go rule/
