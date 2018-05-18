pragma solidity ^0.4.15;

contract ProofOfExistence {
    mapping (bytes32 => bool) private proofs;
    // store a proof of existence in the contract state
    function storeProof(bytes32 proof) private {
        proofs[proof] = true;
    }
    // calculate and store the proof for a document
    function notarize(string document) public {
        bytes32 proof = proofFor(document);
        storeProof(proof);
    }
    // helper function to get a document's sha256
    function proofFor(string document) private pure returns (bytes32) {
        return keccak256(document);
    }
    // check if a document has been notarized
    function checkDocument(string document) public constant returns (bool) {
        bytes32 proof = proofFor(document);
        return hasProof(proof);
    }
    // returns true if proof is stored
    function hasProof(bytes32 proof) private constant returns(bool) {
        return proofs[proof];
    }
}