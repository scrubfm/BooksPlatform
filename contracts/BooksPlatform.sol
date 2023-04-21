// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BooksToken.sol";
import "./BooksNFT.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BooksPlatform is ReentrancyGuard, Ownable {
    BooksToken private _booksToken;
    BooksNFT private _booksNFT;
    uint256 private _burnCost;
    bool private _burnEnabled;

    constructor(BooksToken booksToken, BooksNFT booksNFT, uint256 burnCost) {
        _booksToken = booksToken;
        _booksNFT = booksNFT;
        _burnCost = burnCost;
        _burnEnabled = true;
    }

    function setBurnCost(uint256 newBurnCost) public onlyOwner {
        _burnCost = newBurnCost;
    }

    function setBurnEnabled(bool enabled) public onlyOwner {
        _burnEnabled = enabled;
    }

    function burnTokensForNFT(string memory tokenURI) public nonReentrant {
        require(_burnEnabled, "BooksPlatform: Token burning is currently disabled");
        require(_booksToken.balanceOf(msg.sender) >= _burnCost, "BooksPlatform: Not enough Books tokens");

        _booksToken.burnFrom(msg.sender, _burnCost);
        _booksNFT.mintNFT(msg.sender, tokenURI);
    }
}