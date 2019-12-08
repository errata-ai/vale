
all: install lint test

install:
	go get ./...
	go install ./...

lint:
	golint ./...
	go vet ./...
	find . -name '*.go' | xargs gofmt -w -s

test:
	go test .
	misspell *.md *.go

clean:
	rm -f *~
	go clean ./...
	git gc

ci: install lint test

docker-ci:
	docker run --rm \
		-e COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN \
		-v $(PWD):/go/src/github.com/client9/plaintext \
		-w /go/src/github.com/client9/plaintext \
		nickg/golang-dev-docker \
		make ci

.PHONY: ci docker-ci
