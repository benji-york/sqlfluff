SHELL := bash
.SHELLFLAGS := -eux -o pipefail -c
.DEFAULT_GOAL := build
.DELETE_ON_ERROR:  # If a recipe to build a file exits with an error, delete the file.
.SUFFIXES:  # Remove the default suffixes which are for compiling C projects.
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

export PIP_DISABLE_PIP_VERSION_CHECK=1
pip-install := ve/bin/pip --no-input install --constraint constraints.txt
pip-check := ve/bin/pip show -q

source_code := src

isort := ve/bin/isort --multi-line=VERTICAL_HANGING_INDENT --trailing-comma --no-sections

########################################################################################
# Build targets
#
# It is acceptable for other targets to implicitly depend on these targets having been
# run.  I.e., it is ok if "make lint" generates an error before "make" has been run.

.PHONY: build
build: ve development-utilities

ve:
	python3.9 -m venv ve
	$(pip-install) -r requirements_dev.txt
	$(pip-install) -e .

ve/bin/%:
	# Install development utility "$*"
	$(pip-install) $*

# Utilities we use during development.
.PHONY: development-utilities
development-utilities: ve/bin/black
development-utilities: ve/bin/tox

########################################################################################
# Test and lint targets

.PHONY: mypy
mypy:
	ve/bin/tox -e mypy

.PHONY: black-check
black-check:
	ve/bin/black -S $(source_code) --check

.PHONY: tox-%
tox-%:
	ve/bin/tox -e $*

.PHONY: lint
lint: tox-linting tox-doclinting tox-docbuild tox-yamllint

.PHONY: test
test:
	ve/bin/tox -e py -- -n 2 test

.PHONY: check
check: lint test

########################################################################################
# Sorce code formatting targets

.PHONY: black
black:
	ve/bin/black -S $(source_code)

########################################################################################
# Cleanup targets

.PHONY: clean-%
clean-%:
	rm -rf $*

.PHONY: clean-pycache
clean-pycache:
	find . -name __pycache__ -delete

.PHONY: clean
clean: clean-ve clean-pycache
