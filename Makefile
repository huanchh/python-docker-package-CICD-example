SHELL := /bin/bash


export CUR_DIR := $(dir $(MKFILE_PATH))

## NOTE: Add this to your .bashrc to enable make target tab completion
##    complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
## Reference: https://stackoverflow.com/a/38415982

help: ## This info
	@echo '_________________'
	@echo '| Make targets: |'
	@echo '-----------------'
	@echo
	@cat Makefile | grep -E '^[a-zA-Z\/_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

build: ## build docker image
	docker build -t python_docker_package_cicd .

up: ## start the app container
	docker run -dp 80:80 python_docker_package_cicd

remake: ## build, and then start the app container
	make build
	make up

down: ## stop the app container
	scripts/stop.sh -s