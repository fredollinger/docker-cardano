#!/usr/bin/bash

cd ~/docker-cardeno
export NETWORK=testnet
docker-compose run cardano-node
