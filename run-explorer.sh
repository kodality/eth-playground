#!/bin/bash

NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
MINER_CONTAINER_NAME="ethereum-$NODE_NAME"

docker rm -f explorer
docker run -d -p 8082:8080 --name explorer -e ETH_HOST=$MINER_CONTAINER_NAME explorer