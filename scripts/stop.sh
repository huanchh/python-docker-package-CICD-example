#!/bin/bash

docker rm $(docker stop $(docker ps -a -q --filter ancestor=python_docker_package_cicd --format="{{.ID}}"))