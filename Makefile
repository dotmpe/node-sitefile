# special rule targets
STRGTS := \
   default \
   info \
   lint \
   test \
   build \
   install \
   update \
   global \
   publish

.PHONY: $(STRGTS)

empty :=
space := $(empty) $(empty)
default:
	@echo 'usage:'
	@echo '# npm [info|update|test]'
	@echo '# grunt [lint|..]'
	@echo '# make [$(subst $(space),|,$(STRGTS))]'

install:
	npm install
	make test

lint:
	grunt lint

# FIXME jasmine from grunt?
test: lint
	NODE_ENV=development coffee test/runner.coffee

update:
	npm update
	bower update

build: TODO.list

info:
	npm run srctree
	npm run srcloc

global:
	npm install -g

VERSION := 0.0.2

publish:
	./build.coffee $(VERSION)
	git push
	git push fury master
	npm publish --tag $(VERSION)
	npm publish

TODO.list: Makefile bin config public lib test ReadMe.rst Gruntfile.js Sitefile.yaml
	grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@

