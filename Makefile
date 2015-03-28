TRGTS := install update build build-clients info test global

empty := 
space := $(empty) $(empty)
default:
	@echo 'usage:'
	@echo '# npm [start|test|run build]'
	@echo '# make [$(subst $(space),|,$(TRGTS))]'

install: test
	npm install

test:
	npm test

global: test
	npm install -g

update:
	npm update
	bower update

build:
	npm run build

info:
	npm run srctree
	npm run srcloc

.PHONY: $(TRGTS)

COFFEE2JS := 

_CLN := \
	$(COFFEE2JS:%.coffee=%.js)

build-clients:
	@for x in $(COFFEE2JS); \
	do \
		coffee --compile $$x; \
	done
	@for x in ./*.build.js; \
	do \
		echo "Found $$x, optimizing..."; \
		r.js -o $$x; \
		echo "$$x done"; \
	done
	@echo "Cleaning..";rm -v $(_CLN)

