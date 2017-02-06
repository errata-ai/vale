BASE_DIR=$(shell echo $$GOPATH)/src/github.com/jdkato/txtlint
BUILD_DIR=./builds
COMMIT= `git rev-parse --short HEAD 2>/dev/null`

VERSION_FILE=$(BASE_DIR)/VERSION
VERSION=$(shell cat $(VERSION_FILE))

LDFLAGS=-ldflags "-s -w -X main.Version=$(VERSION) -X main.Commit=$(COMMIT)"

.PHONY: clean test lint ci cross install bump rules setup

all: rules build

build:
	go build ${LDFLAGS} -o bin/txtlint

build-win:
	go build ${LDFLAGS} -o bin/txtlint.exe

cross:
	mkdir -p $(BUILD_DIR)

	GOOS=linux GOARCH=amd64 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/linux-amd64.tar.gz" ./txtlint

	GOOS=linux GOARCH=386 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/linux-386.tar.gz" ./txtlint

	GOOS=darwin GOARCH=amd64 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/darwin-amd64.tar.gz" ./txtlint

	GOOS=darwin GOARCH=386 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/darwin-386.tar.gz" ./txtlint

	GOOS=windows GOARCH=amd64 go build ${LDFLAGS}
	zip -r "$(BUILD_DIR)/windows-amd64.zip" ./txtlint.exe

	GOOS=windows GOARCH=386 go build ${LDFLAGS}
	zip -r "$(BUILD_DIR)/windows-386.zip" ./txtlint.exe

	rm -rf txtlint txtlint.exe

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
		./util ./ui ./lint

setup:
	go get -u github.com/alecthomas/gometalinter
	go get -u github.com/stretchr/testify/assert
	go get -u github.com/urfave/cli
	go get -u github.com/jteeuwen/go-bindata/...
	go-bindata -ignore=\\.DS_Store -pkg="rule" -o rule/rule.go rule/
	go get ./util ./ui ./lint
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
