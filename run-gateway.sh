#!/bin/bash

NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
MINER_CONTAINER_NAME="ethereum-$NODE_NAME"

docker rm -f gateway
docker run -d --network ethereum -p 8081:8080 -e ETH_HOST=$MINER_CONTAINER_NAME --name gateway gateway