VERSION=`git log | head -1 | awk '{print $$2}'`
GOPATH=`go env GOPATH`/bin
export PATH := /usr/local/go/bin:$(HOME)/go/bin:/usr/local/bin:$(PATH)

build: install-golang clean 
	go build

arm64: GOARCH := arm64
arm64: clean 
	mkdir -p build
	GOARCH=${GOARCH} go build -o build/meezy.${GOARCH}.${VERSION}

amd64: GOARCH := amd64
amd64: 
	mkdir -p build
	GOARCH=${GOARCH} go build -o build/meezy.${GOARCH}.${VERSION}

package-nginx: 
	scripts/generate_nginx.sh ${VERSION}
	ls build

test: install-golang 
	scripts/test_coverage.sh

tidy: install-golang
	go mod tidy

markup-lint: css-lint html-lint yamllint

install-npm:
	scripts/install_npm.sh

install-yamllint:
	scripts/install_yamllint.sh

install-purgecss: install-npm
	npm i -g purgecss@latest

install-stylelint: install-npm
	npm i -g stylelint@latest
	npm i -g stylelint-config-standard@latest

install-html-validate: install-npm
	npm i -g html-validate@latest

install-golang: make-lint
	scripts/checkGoVersion.sh

html-lint: install-weblint
	./scripts/html-validate.sh

css-lint: install-weblint
	./scripts/purgecss.sh
	./scripts/stylelint.sh

install-weblint: install-npm
	npm --no-audit --progress=false i -g html-validate@latest purgecss@latest stylelint@latest stylelint-config-standard@latest

vet: install-golang
	go vet

install-govulncheck: install-golang
	go install golang.org/x/vuln/cmd/govulncheck@latest

vuln: install-govulncheck
	govulncheck ./*.go

install-golang-ci: install-golang
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

ci-lint: install-golang-ci
	golangci-lint run

yamllint: install-yamllint
	yamllint .github/workflows/github-actions*.yml
	yamllint .golangci.yml

make-lint: 
	make -n all 1>/dev/null

lint: make-lint go-lint markup-lint 

go-lint: install-golang ci-lint vuln

clean: install-golang
	rm -rf build
	go clean
	echo {{define \"content\"}}${VERSION}{{end}} > www/meezeefit/version.html

run: build install-golang
	./meezy

package: install-golang arm64 package-nginx vuln tidy markup-lint
	rm -f package-${VERSION}.zip
	mkdir -p build
	cd build && zip -r ../package-${VERSION}.zip ./*.*
	cd ..
	scripts/upload_to_aws.sh package-${VERSION}.zip
	rm -f package-${VERSION}.zip

cache-archive: install-golang
	rm -rf cache.tar.gz
	rm -rf bleve.tar.gz
	tar -czf cache.tar.gz cache
	tar -czf bleve.tar.gz db.bleve

cache-install:
	test -f cache.tar.gz && rm -rf cache || echo "no cache.tar.gz"
	test -f cache.tar.gz && tar -xzf cache.tar.gz  || echo "no cache.tar.gz"
	test -f bleve.tar.gz && rm -rf db.bleve || echo "no bleve.tar.gz"
	test -f bleve.tar.gz && tar -xzf bleve.tar.gz  || echo "no bleve.tar.gz"

version: 
	echo ${VERSION}

local: tidy lint build test

all: local package 
