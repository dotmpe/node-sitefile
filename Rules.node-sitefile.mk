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
	grunt lint

TEST += jasmine

jasmine:
	grunt test

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


