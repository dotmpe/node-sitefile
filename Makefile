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
   version \
   check \
   increment \
   publish

.PHONY: $(STRGTS)

# BSD weirdness
echo = /bin/echo

empty :=
space := $(empty) $(empty)
default: info
	@echo 'usage:'
	@echo '# npm [info|update|test]'
	@echo '# grunt [lint|..]'
	@echo '# make [$(subst $(space),|,$(STRGTS))]'

install:
	npm install
	bower install
	make test

lint:
	grunt lint

# FIXME jasmine from grunt?
test:
	coffee test/runner.coffee

update:
	./tools/cli-version.sh update
	npm update
	bower update

build: TODO.list

TODO.list: Makefile bin config doc example lib public test tools ReadMe.rst Gruntfile.js Sitefile.yaml
	grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@

global:
	npm install -g

info:
	./tools/cli-version.sh
	npm run srctree
	npm run srcloc

IGNORE_DIRS := components node_modules bower_components .git

srclist:
	find ./ $(addprefix -not -path ,$(IGNORE_DIRS:%='*%*'))

version:
	@./tools/cli-version.sh version

check:
	@$(echo) -n "Checking for version "
	@./tools/cli-version.sh check

patch: m :=
patch:
	@./tools/cli-version.sh increment
	@./tools/prep-version.sh
	@[ -z "$(m)" ] || { git add -u && git ci -m '$(m)' }

# XXX: GIT publish
publish: DRY := yes
publish: check
	@[ -z "$(VERSION)" ] && exit 1 || echo Publishing $(./tools/cli-version.sh version)
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


