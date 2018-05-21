# Blockchain based document notarization PoC

## The problem
It's  often required to make sure that medical data stored in some database is not changed once it have been created.
 
## Blockchain as possible solution

### What is blockchain 
A blockchain is a decentralized, distributed and public digital ledger that is used to record transactions across many computers so that the record cannot be altered retroactively without the alteration of all subsequent blocks and the collusion of the network.

Blockchains can store data as well, making it tamper-proof.

### Ethereum
Ethereum is an open-source, public, blockchain-based distributed computing platform and operating system featuring smart contract (scripting) functionality. (https://www.ethereum.org/)

Using ethereum smart contracts it is possible to achieve required document notarization and validation having a small ethreum cluster (3-5 nodes), which will ensure security of the protocol.

## "Proof of existence" smart contract

Smart contract should be able to perform two operations:
1. Document notarization - "signing" the document in the blockchain
2. Document check - checking if document is already "signed"

Pseudocode:
```$xslt
contract ProofOfExistence {
   
    // calculate and store the proof for a document
    function notarize(string document) public {}
   
    // check if proof exists for cpecified document
    function checkDocument(string document) public constant returns (bool) {}
}
```
Currently document itself isn't stored on the blockchain, only the hash value stored (which is calculated by ethereum nodes). But it's possible to store whole document as well.

## PoC components
1. Harmony - single Ethereum peer for private network that performs block mining operations and provides simple UI as well (https://github.com/ether-camp/ethereum-harmony)
2. Gateway -  that deploys smart contract to the blockchain and acts as a gateway between client and blockchain providing 2 REST endpoints to notarize and check documents. It uses truffle framework to compile and deploy smart contracts. (http://truffleframework.com/)

### Harmony deployment

`docker-compose up` to build and start docker image

Shortly UI will be accessible from http://localhost:8080/

It will take around 10 minutes to build DAG (https://github.com/ethereum/wiki/wiki/Ethash-DAG). Since it mounted to local `./ethashe` folder, this process will be done only once.

**NB! Docker host requires at least 3.5 GB of RAM**

### Gateway deployment

`docker-compose up` to deploy smart contracts and start REST gateway server

**NB! Make sure Harmony finished with DAG before running this**


## REST API

API is available under 8088 port by default

JSON documents are converted to canonical form (https://www.npmjs.com/package/canonical-json) before calculating hash value

### Notarization

**URL** : `/notarize`

**Method** : `POST`

**Payload** : Free form json to notarize.

```json
{
    "some_key": "some value"
}
```

#### Success Response

**Condition** : If everything is OK and document hash is stored on the blockchain.

**Code** : `200 OK`

#### Error Responses

**Condition** : If something goes wrong

**Code** : `500	Internal Server Error`

**Content** : `Exception or error message why it failed`

### Document check

**URL** : `/documentCheck`

**Method** : `POST`

**Payload** : Free form json document to check.

```json
{
    "some_key": "some value"
}
```

#### Success Response

**Condition** : If document is stored on the blockchain.

**Code** : `200 OK`

#### Error Responses

**Condition** : If document is not stored on the blockchain or request failed.

**Code** : `500	Internal Server Error`

**Content** : `Exception or error message why request failed or message "Document was modified or haven't been notarized."`






