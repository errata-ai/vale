CONTAINER=nickg/misspell

build:
	cp precommit.sh .git/hooks/pre-commit
	go install ./cmd/misspell
	gometalinter \
		 --vendor \
		 --deadline=60s \
	         --disable-all \
		 --enable=vet \
		 --enable=golint \
		 --enable=gofmt \
		 --enable=goimports \
		 --enable=gosimple \
		 --enable=staticcheck \
		 --enable=ineffassign \
		 --exclude=/usr/local/go/src/net/lookup_unix.go \
		 ./...
	go test .


# the grep in line 2 is to remove misspellings in the spelling dictionary
# that trigger false positives!!
falsepositives: /scowl-wl
	cat /scowl-wl/words-US-60.txt | \
		grep -i -v -E "payed|Tyre|Euclidian|nonoccurence|dependancy|reenforced|accidently|surprize|dependance|idealogy|binominal|causalities|conquerer|withing|casette|analyse|analogue|dialogue|paralyse|catalogue|archaeolog|clarinettist|catalyses|cancell|chisell|ageing|cataloguing" | \
		misspell -locale=US -debug -error
	cat /scowl-wl/words-US-60.txt | tr '[:lower:]' '[:upper:]' | \
		grep -i -v -E "payed|Tyre|Euclidian|nonoccurence|dependancy|reenforced|accidently|surprize|dependance|idealogy|binominal|causalities|conquerer|withing|casette|analyse|analogue|dialogue|paralyse|catalogue|archaeolog|clarinettist|catalyses|cancell|chisell|ageing|cataloguing" | \
		 misspell -locale=US -debug -error
	cat /scowl-wl/words-GB-ise-60.txt | \
		grep -v -E "payed|nonoccurence|withing" | \
		misspell -locale=UK -debug -error
	cat /scowl-wl/words-GB-ise-60.txt | tr '[:lower:]' '[:upper:]' | \
		grep -i -v -E "payed|nonoccurence|withing" | \
		misspell -debug -error
#	cat /scowl-wl/words-GB-ize-60.txt | \
#		grep -v -E "withing" | \
#		misspell -debug -error
#	cat /scowl-wl/words-CA-60.txt | \
#		grep -v -E "withing" | \
#		misspell -debug -error

bench:
	go test -bench '.*'

clean:
	go clean ./...
	git gc

ci:
	type dmnt >/dev/null 2>&1 || go get -u github.com/client9/dmnt
	docker run --rm \
		$(shell dmnt .) \
		-w /go/src/github.com/client9/misspell \
		${CONTAINER} \
		make build falsepositives

travis:
	docker --version
	docker run --rm \
		-v ${PWD}:/go/src/github.com/client9/misspell \
		-w /go/src/github.com/client9/misspell \
		${CONTAINER} \
		make build falsepositives

docker-build:
	docker build -t ${CONTAINER} .

console:
	docker run --rm -it \
		$(shell dmnt .) \
		-w /go/src/github.com/client9/misspell \
		${CONTAINER} sh

.PHONY: ci console docker-build bench
