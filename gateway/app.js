import express from 'express'
import contract from 'truffle-contract'
import proofOfExistence from '../build/contracts/ProofOfExistence.json'
import Web3 from 'web3'
import TruffleConfig from '../truffle'
import bodyParser from 'body-parser'
import stringify from 'canonical-json'

const PORT = 8088;

const app = express();
app.use(bodyParser.json());       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));

const config = TruffleConfig.networks.development;
const ProofOfExistence = contract(proofOfExistence);

let poe;

app.listen(PORT, function() {

  let host = 'http://' + config.host + ':' + config.port;
  console.log("connecting to ethereum rpc at: " + host);

  let httpProvider = new Web3.providers.HttpProvider(host);

  new Web3(httpProvider).eth.defaultAccount = config.from;

  ProofOfExistence.setProvider(httpProvider);
  ProofOfExistence.defaults({
    gas: config.gas
  });
  ProofOfExistence.deployed().then(function(contract) {
    poe = contract;
  }).catch(function(e) {
    console.log(e);
  });

  console.log("Server is up and running at: http://localhost:" + PORT)
});

app.post('/notarize', function(req, res) {
  let payload = req.body;
  let document = stringify(payload.document);

  poe.notarize.call(payload.id, document).then(function(result) {
    if (result === '0x') {
      return res.status(500).send("Failed to notarize document, given id already exist");
    }
    poe.notarize(payload.id, document).then(function(txReceipt) {
      console.log(txReceipt);
      console.log("Document with id " + payload.id + " is notarized, result hash: " + result);
      return res.send(result);
    });
  }).catch(function(e) {
    return res.status(500).send("Failed to notarize document with id " + payload.id + ": " + e.message);
  });
});

app.post('/checkDocument', function(req, res) {
  let payload = req.body;
  let document = stringify(payload.document);

  poe.checkDocument.call(payload.id, document).then(function(result) {
    console.log("Document checked by content and id: " + payload.id);
    return res.status(200).send(result === true);
  }).catch(function(e) {
    console.log(e);
    return res.status(500).send("Failed to check document: " + e.message);
  });
});

app.post('/checkDocumentId', function(req, res) {
  let id = req.body.id;

  poe.checkDocumentId.call(id).then(function(result) {
    console.log("Document checked by id: " + id);
    return res.status(200).send(result === true);
  }).catch(function(e) {
    console.log(e);
    return res.status(500).send("Failed to check document by id: " + e.message);
  });
});

app.get('/documentIds', function(req, res) {
  poe.getTotalDocumentsCount.call().then(function(count) {
    let promises = [];
    for (let i = 0; i < count; i++) {
      promises.push(new Promise(function(resolve) {
        poe.getDocumentIdByIndex.call(i).then(function(id) {
          console.log("resolved " + id);
          resolve(id);
        });
      }));
    }

    Promise.all(promises).then(function(results) {
      return res.status(200).send(results);
    });
  }).catch(e => {
    console.log(e);
    return res.status(200).send(e);
  });
});