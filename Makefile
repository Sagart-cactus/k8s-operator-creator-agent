.PHONY: dev kind deploy verify prereqs

dev:
	tilt up

kind:
	./scripts/setup-kind.sh

deploy:
	./scripts/deploy-dev.sh

verify:
	./scripts/verify-dev.sh

prereqs:
	./scripts/prereqs.sh
