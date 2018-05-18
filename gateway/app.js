import express from 'express'
import contract from 'truffle-contract'
import proofOfExistence from '../build/contracts/ProofOfExistence.json'
import Web3 from 'web3'
import TruffleConfig from '../truffle'
import bodyParser from 'body-parser'
import stringify from 'canonical-json'


const app = express();
app.use(bodyParser.json());       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
    extended: true
}));

const config = TruffleConfig.networks.development;
const ProofOfExistence = contract(proofOfExistence);

let poe;

app.post('/notarize', function (req, res) {
    let document = stringify(req.body);
    poe.notarize(document).then(function (ignored) {
        console.log("DOCUMENT NOTARIZED: " + document);
        return res.send(req.body);
    }).catch(function (e) {
        console.log(e);
        return res.status(500).send("Failed to notarize document: " + e.message);
    });
});


app.post('/checkDocument', function (req, res) {
    let document = stringify(req.body);
    poe.checkDocument(document).then(function (result) {
        console.log("DOCUMENT CHECKED: " + document);
        if (result === true) {
            return res.status(200).send();
        } else {
            return res.status(500).send("Document was modified or haven't been notarized.");
        }
    }).catch(function (e) {
        console.log(e);
        return res.status(500).send("Failed to notarize document: " + e.message);
    });
});

app.listen(8080, function () {

    let host = 'http://' + config.host + ':' + config.port;
    console.log("connecting to ethereum rpc at: " + host);

    let httpProvider = new Web3.providers.HttpProvider(host);

    new Web3(httpProvider).eth.defaultAccount = config.from;

    ProofOfExistence.setProvider(httpProvider);
    ProofOfExistence.defaults({
        gas: config.gas
    });
    ProofOfExistence.deployed().then(function (contract) {
        poe = contract;
    }).catch(function (e) {
        console.log(e);
    });

    console.log("Server is up and running!")
});