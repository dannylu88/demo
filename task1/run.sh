#!/bin/sh

# Docker compose is better, but we can do it later lol..
# Build docker file
docker build -t coffee-0 -f build/build-image/Dockerfile .

# Run docker container
docker run -p 8082:8082 coffee-0