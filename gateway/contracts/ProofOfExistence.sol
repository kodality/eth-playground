pragma solidity ^0.4.19;

contract ProofOfExistence {

    mapping(string => bytes32) private proofs;
    string[] documentIds;

    // store a proof of existence in the contract state
    function storeProof(string documentId, bytes32 proof) private {
        documentIds[documentIds.length++] = documentId;
        proofs[documentId] = proof;
    }
    // calculate and store the proof for a document and return hash
    function notarize(string documentId, string document) public returns (bytes32) {
        if(checkDocumentId(documentId)){
            revert();
            return '0x'; // we shouldn't update proof for an existing document id
        }
        bytes32 proof = proofFor(document);
        storeProof(documentId, proof);
        return proof;
    }
    // helper function to get a document's hash in keccak256
    function proofFor(string document) private pure returns (bytes32) {
        return keccak256(document);
    }
    // check if a document has been notarized and unchanged
    function checkDocument(string documentId, string document) public constant returns (bool) {
        return checkDocumentId(documentId) && proofs[documentId] == proofFor(document);
    }
    // check if a document with specified id has been notarized
    function checkDocumentId(string documentId) public constant returns (bool) {
        return proofs[documentId] != 0;
    }
    // return total count of documents notarized
    function getTotalDocumentsCount() public constant returns (uint) {
        return documentIds.length;
    }
    // retrieves document id by given index, max value is getTotalDocumentsCount() - 1
    function getDocumentIdByIndex(uint index) public constant returns (string) {
        return documentIds[index];
    }
}