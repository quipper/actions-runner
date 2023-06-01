# This Makefile generates a Dockerfile from upstream with multi-architectures patch.
# It is needed until GitHub officially provides a multi-architectures image.
# https://github.com/orgs/community/discussions/56720

all: Dockerfile.generated

Dockerfile.official:
ifndef RUNNER_VERSION
	$(error usage: make RUNNER_VERSION=x.y.z)
endif
	curl -sf -o $@ https://raw.githubusercontent.com/actions/runner/v$(RUNNER_VERSION)/images/Dockerfile

Dockerfile.multiarch: Dockerfile.official multiarch.patch
	patch -o $@ Dockerfile.official multiarch.patch

Dockerfile.generated: Dockerfile.multiarch ../Dockerfile
	echo '### DO NOT EDIT BELOW' > $@
	echo '### BEGIN OF GENERATED BLOCK' >> $@
	cat Dockerfile.multiarch >> $@
	echo '### END OF GENERATED BLOCK' >> $@
	# https://stackoverflow.com/questions/197150/skip-file-lines-until-a-match-is-found-then-output-the-rest
	sed -e '1,/^### END OF GENERATED BLOCK/d' ../Dockerfile >> $@
