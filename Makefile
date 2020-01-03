LAST_TAG=$(shell git describe --abbrev=0 --tags)
CURR_SHA=$(shell git rev-parse --verify HEAD)

LDFLAGS=-ldflags "-s -w -X main.version=$(LAST_TAG)"
BUILD_DIR=./builds

.PHONY: data test lint install rules setup bench compare release

all: build

# make release tag=v0.4.3
release:
	git tag $(tag)
	git push origin $(tag)

build:
	go build ${LDFLAGS} -o bin/vale

closed:
	go build -tags closed ${LDFLAGS} -o bin/vale

build-win:
	go build ${LDFLAGS} -o vale.exe
	go-msi make --msi vale.msi --version $(LAST_TAG)

install:
	go install ${LDFLAGS}

spell:
	./bin/vale --glob='!*{Needless,Diacritical,DenizenLabels,AnimalLabels}.yml' rule styles

bench:
	go test -bench=. -benchmem ./core ./lint ./check

compare:
	cd lint && \
	benchmany -n 5 -o new.txt ${CURR_SHA} && \
	benchmany -n 5 -o old.txt ${LAST_TAG} && \
	benchcmp old.txt new.txt && \
	benchstat old.txt new.txt

lint:
	gometalinter --vendor --disable-all \
		--enable=deadcode \
		--enable=ineffassign \
		--enable=gosimple \
		--enable=staticcheck \
		--enable=goimports \
		--enable=dupl \
		--enable=misspell \
		--enable=errcheck \
		--enable=vet \
		--enable=vetshadow \
		--deadline=1m \
		./core ./lint ./ui ./check

setup:
	go get golang.org/x/perf/cmd/benchstat
	go get golang.org/x/tools/cmd/benchcmp
	go get github.com/aclements/go-misc/benchmany
	go get -u github.com/jteeuwen/go-bindata/...
	bundle install
	gem specific_install -l https://github.com/jdkato/aruba.git -b d-win-fix

rules:
	go-bindata -ignore=\\.DS_Store -pkg="rule" -o rule/rule.go rule/**/*.yml

data:
	go-bindata -ignore=\\.DS_Store -pkg="data" -o data/data.go data/*.{dic,aff}

test:
	go test -race ./core ./lint ./check
	cucumber

docker:
	GOOS=linux GOARCH=amd64 go build -tags closed ${LDFLAGS} -o bin/vale
	docker login -u jdkato -p ${DOCKER_PASS}
	docker build -f Dockerfile -t jdkato/vale:latest .
	docker tag jdkato/vale:latest jdkato/vale:latest
	docker push jdkato/vale

cross:
	mkdir -p $(BUILD_DIR)

	GOOS=linux GOARCH=amd64 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/vale_$(LAST_TAG)_Linux_64-bit.tar.gz" ./vale

	rm -rf vale

	GOOS=darwin GOARCH=amd64 go build ${LDFLAGS}
	tar -czvf "$(BUILD_DIR)/vale_$(LAST_TAG)_macOS_64-bit.tar.gz" ./vale

	rm -rf vale

	GOOS=windows GOARCH=amd64 go build ${LDFLAGS}
	zip -r "$(BUILD_DIR)/vale_$(LAST_TAG)_Windows_64-bit.zip" ./vale.exe

	rm -rf vale.exe
