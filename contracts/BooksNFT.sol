// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract BooksNFT is ERC721, Ownable, ReentrancyGuard, Pausable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public mintCost;
    address public newContractAddress;

    constructor() ERC721("BooksNFT", "BKT") {}

    function mintNFT(address to, string memory _tokenURI) public payable whenNotPaused nonReentrant returns (uint256) {
        require(msg.value >= mintCost, "Insufficient payment for minting.");

        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        _safeMint(to, tokenId);
    
        return tokenId;
    }

    function burn(uint256 tokenId) public onlyOwner nonReentrant {
        _burn(tokenId);
    }

    function setMintCost(uint256 _mintCost) public onlyOwner {
        mintCost = _mintCost;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function addNewContract(address _newContractAddress) public onlyOwner {
        newContractAddress = _newContractAddress;
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}