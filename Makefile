.PHONY: validate lint test

validate: lint test

lint:
	actionlint
	shellcheck scripts/*.sh tests/*.sh

test:
	tests/check-pr-title.test.sh
