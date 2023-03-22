// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Certification is ERC721URIStorage {

    address Owner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Certification", "Cert") {
        Owner = msg.sender;
    }
    mapping (address => bool) public issuedCert;

    modifier onlyOwner() {
        require(msg.sender == Owner);
        _;
    }

    function issueCert(address to) onlyOwner external {
        issuedCert[to] = true;
    }

    function claimCert(string memory tokenURI) public returns (uint256){
        require(issuedCert[msg.sender], "Cert is not issued");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        personToCert[msg.sender] = tokenURI;
        issuedCert[msg.sender] = false;

        return newItemId;
    }

    mapping (address => string) public personToCert;


}