#!/bin/bash
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"miner1"}

./run-node.sh $NODE_NAME --mine --minerthreads=1
