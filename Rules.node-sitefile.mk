# Makefile for personal use calling other builders, don't use in build systems but call directly

# special rule targets (also PHONY)
STRGT += \
   lint \
   test \
   update \
   global \
   docker \
   docker-pub \
   docker-run \
   docker-dev \
   version \
   check \
   increment \
   publish

# BSD weirdness
echo = /bin/echo

grunt_bin := ./node_modules/.bin/grunt

empty :=
space := $(empty) $(empty)
default::
	@echo 'usage:'
	@echo '# npm [info|update|test]'
	@echo '# grunt [lint|..]'
	@echo '# make [$(subst $(space),|,$(STRGT))]'

install::
	npm install
	bower install
	make test

lint:
	NODE_ENV=testing $(grunt_bin) lint

TEST += jasmine

jasmine:
	NODE_ENV=testing $(grunt_bin) test

update:
	./bin/sitefile-cli.coffee update
	npm update
	bower update

global:
	npm install -g

docker:
	cd tools/docker/ubuntu && \
		docker build --build-arg sf_build_ver=r0.0.7 -t dotmpe/node-sitefile:edge .

docker-pub: docker
	docker push dotmpe/node-sitefile:edge

docker-run:
	docker run --rm -p 7011:7011 -ti \
		dotmpe/node-sitefile:edge

docker-dev: hostname := $(shell hostname -f)
docker-dev:
	docker run --rm -p 7011:7011 -ti \
		--hostname sf.$(hostname) \
		-e src_update=0 \
		-e SITEFILE_HOST=sf.$(hostname) \
		-v $$PWD:/src/github.com/dotmpe/node-sitefile/ \
		dotmpe/node-sitefile:edge

build:: docker TODO.list

TODO.list: Makefile lib ReadMe.rst reader.rst package.yaml Sitefile.yaml
	grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@

info::
	@echo "Id: "$(shell ./bin/sitefile-cli.coffee app-id)
	@echo "Version: "$(shell ./bin/sitefile-cli.coffee version)
	@echo "Source Files: "$(shell npm run src-files | tail -n +5 | wc -l | awk '{print $$1}')
	@echo "Lines-of-Code: "$(shell npm run src-loc | tail -n +5 )
	@echo "Local Node Dependencies: "$(shell npm run dep-local | tail -n +5 | wc -l | awk '{print $$1}')
	@echo "All Local Node Packages: "$(shell npm run dep-local-all | tail -n +5 | wc -l | awk '{print $$1}')

version:
	@./bin/sitefile-cli.coffee --version

check: version lint

# TODO: cleanup


.build/js/sitefile: ./lib
	$(grunt_bin) coffee:lib
.build/js/sitefile-dev:
	$(grunt_bin) coffee:dev
.build/js/sitefile-test:
	$(grunt_bin) coffee:test


PRETTYG := ./tools/sh/prettify-madge-graph.sh

assets/%-deps.dot: .build/js/% .madgerc Rules.node-sitefile.mk $(PRETTYG)
	madge --include-npm --dot .build/js/$* | $(PRETTYG) .build/js/sitefile "sitefile" > $@

assets/%.dot: .build/js/% .madgerc $(PRETTYG) Rules.node-sitefile.mk
	madge --dot .build/js/$* | $(PRETTYG) .build/js/$* > $@

assets/%-deps.svg: assets/%-deps.dot .build/js/% Rules.node-sitefile.mk
	dot -Grankdir=LR -Tsvg assets/$*-deps.dot -Nshape=record > $@

assets/%.svg: assets/%.dot .build/js/% Rules.node-sitefile.mk
	dot -Grankdir=LR -Tsvg assets/$*.dot -Nshape=record > $@

LIB_DEP_G_DOT := \
	assets/sitefile.dot \
	assets/sitefile-deps.dot \
	assets/sitefile-test-deps.dot \
	assets/sitefile-dev-deps.dot
LIB_DEP_G_SVG := \
	assets/sitefile.svg \
	assets/sitefile-deps.svg \
	assets/sitefile-test-deps.svg \
	assets/sitefile-dev-deps.svg

dep-g-dot:: $(LIB_DEP_G_DOT)
dep-g-svg:: $(LIB_DEP_G_SVG)

dep-g:: $(LIB_DEP_G_SVG) $(LIB_DEP_G_DOT)
