#!/bin/bash
IMGNAME="ethereum/client-go:v1.8.8"

NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"

DATA_ROOT=${DATA_ROOT:-"$(pwd)/.ether-$NODE_NAME"}
DATA_HASH=${DATA_HASH:-"$(pwd)/.ethash"}

echo "Destroying old container $CONTAINER_NAME..."
docker rm -f $CONTAINER_NAME

RPC_PORTMAP=
RPC_ARG=
if [[ ! -z $RPC_PORT ]]; then
    RPC_ARG='--rpc --rpcaddr=0.0.0.0 --rpcapi=db,eth,net,web3,personal --rpccorsdomain=* --rpcvhosts=*'
    RPC_PORTMAP="-p $RPC_PORT:8545"
fi

BOOTNODE_URL=${BOOTNODE_URL:-$(./getbootnodeurl.sh)}

if [ ! -d $DATA_ROOT/geth ]; then
    echo "$DATA_ROOT/geth not found, running 'geth init'..."
    docker run --rm \
        -v $DATA_ROOT:/root/.ethereum \
        -v $(pwd)/genesis.json:/opt/genesis.json \
        $IMGNAME init /opt/genesis.json
    echo "...done!"
fi

if [ ! "$(ls -A $DATA_ROOT/keystore)" ]; then
    ADDRESS=$(docker run --rm \
        -v $DATA_ROOT:/root/.ethereum \
        -v $(pwd)/genesis.json:/opt/genesis.json \
        -v $(pwd)/gateway/cred:/opt/cred \
        $IMGNAME --password /opt/cred account new | awk '{print $2}' | tr -d '{}')
    echo "Created address for $CONTAINER_NAME - $ADDRESS, update genesis.json file"
fi

echo "Running new container $CONTAINER_NAME..."
docker run -d --name $CONTAINER_NAME \
    --network ethereum \
    -v $DATA_ROOT:/root/.ethereum \
    -v $DATA_HASH:/root/.ethash \
    -v $(pwd)/genesis.json:/opt/genesis.json \
    $RPC_PORTMAP \
    $IMGNAME --bootnodes=$BOOTNODE_URL $RPC_ARG --cache=512 --verbosity=4 --maxpeers=3 ${@:2}
