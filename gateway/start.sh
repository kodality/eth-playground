#!/bin/sh

ACCOUNT_PASSWORD=`cat cred` truffle migrate --reset --clean
npm start