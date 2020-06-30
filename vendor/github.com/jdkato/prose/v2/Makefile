BASE_DIR=$(shell echo $$GOPATH)/src/github.com/jdkato/prose
BUILD_DIR=./builds

LDFLAGS=-ldflags "-s -w"

.PHONY: clean test lint ci cross install bump model setup

all: build

build:
	go build ${LDFLAGS} -o bin/prose ./cmd/prose

build-win:
	go build ${LDFLAGS} -o bin/prose.exe ./cmd/prose

bench:
	go test -bench=. -run=^$$ -benchmem

test:
	go test -v

ci: lint test

lint:
	./bin/golangci-lint run

setup:
	go get -u github.com/shogo82148/go-shuffle
	go get -u github.com/willf/pad
	go get -u github.com/montanaflynn/stats
	go get -u gopkg.in/neurosnap/sentences.v1/english
	go get -u github.com/stretchr/testify/assert
	go get -u github.com/urfave/cli
	go get -u github.com/jteeuwen/go-bindata/...
	go get -u github.com/deckarep/golang-set
	go get -u github.com/mingrammer/commonregex
	go get -u gonum.org/v1/gonum/mat

model:
	go-bindata -ignore=\\.DS_Store -pkg="prose" -o data.go model/**/*.gob
