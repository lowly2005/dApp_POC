pragma solidity ^0.6.9;

contract SignDocument {

    mapping (bytes32 => bool) documentProof;
    mapping (string => string) reportInfos;
    mapping (string => bytes32) patientReport;
    
    function submit(
        string memory patientId,
        string memory patientSignature,
        string memory doctorSignature,
        string memory entitySignature,
        string memory reportIdentifier,
        string memory document) public {
        bytes32 signedDocument = signDoc(document);
        storeDocumentProof(patientId, patientSignature, doctorSignature, entitySignature, reportIdentifier, signedDocument);
    }
    
    function signDoc(string memory document) private pure returns (bytes32) {
        return sha256(abi.encodePacked(document));
    }
    
    function storeDocumentProof(
        string memory patientId,
        string memory patientSignature,
        string memory doctorSignature,
        string memory entitySignature,
        string memory reportIdentifier,
        // EncryptionKey
        bytes32 signedDocument) private {
        
        string memory infos = string(abi.encodePacked(patientId, patientSignature, doctorSignature, entitySignature, reportIdentifier));
        reportInfos[patientId] = infos;
        patientReport[patientId] = signedDocument;
        documentProof[signedDocument] = true;
    }
    // User patientID + signature to get the report hash + entitySignature  and use it to search for the report
    function checkReport (string memory document) public view returns (bool) {
        bytes32 signedDocument = signDoc(document);
        return hasProof(signedDocument);
    }

    function getReportInfos (string memory patientId) public view returns (bytes32) {
        return patientReport[patientId];
    }
    
    function hasProof(bytes32 signedDocument) private view returns (bool) {
        return documentProof[signedDocument];
    }
}