# Makefile for personal use calling other builders, don't use in build systems but call directly

# special rule targets
STRGT += \
   lint \
   test \
   update \
   global \
   version \
   check \
   increment \
   publish

# BSD weirdness
echo = /bin/echo

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
	NODE_ENV=testing grunt lint

TEST += jasmine

jasmine:
	NODE_ENV=testing grunt test

update:
	./bin/cli-version.sh update
	npm update
	bower update

global:
	npm install -g

build:: TODO.list

TODO.list: Makefile lib ReadMe.rst reader.rst package.yaml Sitefile.yaml
	grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@

info::
	@echo "Id: "$(shell ./bin/cli-version.sh app-id)
	@echo "Version: "$(shell ./bin/cli-version.sh version)
	@echo "Source Files: "$(shell npm run src-files | tail -n +5 | wc -l | awk '{print $$1}')
	@echo "Lines-of-Code: "$(shell npm run src-loc | tail -n +5 )
	@echo "Local Node Dependencies: "$(shell npm run dep-local | tail -n +5 | wc -l | awk '{print $$1}')
	@echo "All Local Node Packages: "$(shell npm run dep-local-all | tail -n +5 | wc -l | awk '{print $$1}')

version:
	@./bin/cli-version.sh version

check:
	@$(echo) -n "Checking for version "
	@./bin/cli-version.sh check

patch: m :=
patch:
	@./bin/cli-version.sh increment
	@./tools/prep-version.sh
	@git add -u && git ci -m '$(m)'

# XXX: GIT publish
publish: DRY := yes
publish: check
	@[ -z "$(VERSION)" ] && exit 1 || echo Publishing $(./bin/cli-version.sh version)
	git push
	@if [ $(DRY) = 'no' ]; \
	then \
		git tag v$(VERSION)
		git push fury master; \
		npm publish --tag $(VERSION); \
		npm publish; \
	else \
		echo "*DRY* $(VERSION)"; \
	fi



.build/js/sitefile: ./lib
	grunt coffee:lib
.build/js/sitefile-dev:
	grunt coffee:dev
.build/js/sitefile-test:
	grunt coffee:test


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
