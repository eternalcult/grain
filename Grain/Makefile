SWIFTFORMAT = swiftformat .

.PHONY: fmt
## fmt: Launch swift files code formatter
fmt:
	$(SWIFTFORMAT)

.PHONY: lint
## lint: Launch swift files linter check
lint:
	$(SWIFTFORMAT) --lint

.PHONY: help
## help: Prints help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /' | sort
