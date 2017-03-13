
STRGT += \
				 build_$d
TRGT += \
				build_$d

build_$d:
	@\
		ENV=testing; \
		SCR_SYS_SH=bash-sh; \
		scriptname=make:build; \
		. ./tools/sh/init.sh; \
		. $$scriptdir/sh/env.sh; \
		. $$scriptdir/ci/build.sh

info::
	@$(ll) header "Id" "$(shell git-versioning app-id)"
	@$(ll) header "Version" "$(shell git-versioning version)"
	@#$(ll) header "Source Files" "$(shell npm run src-files | tail -n +5 | wc -l | awk '{print $$1}')"
	@#$(ll) header "Lines-of-Code" "$(shell npm run src-loc | tail -n +5 )"
	@$(ll) header "Local Node Dependencies" "$(shell npm run dep-local | tail -n +5 | wc -l | awk '{print $$1}')"
	@$(ll) header "All Local Node Packages" "$(shell npm run dep-local-all | tail -n +5 | wc -l | awk '{print $$1}')"

