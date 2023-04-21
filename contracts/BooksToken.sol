// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BooksToken is ERC20, ERC20Burnable, Ownable {
    uint256 private _maxSupply = 2 * (10 ** 15); // 2 quadrillion tokens (since 18 decimal places by default)
    uint256 private _tokenPrice;

    constructor(uint256 initialTokenPrice) ERC20("Books", "BOOK") {
        _tokenPrice = initialTokenPrice;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= _maxSupply, "BooksToken: Exceeds max supply");
        _mint(to, amount);
    }

    function setTokenPrice(uint256 newTokenPrice) public onlyOwner {
        _tokenPrice = newTokenPrice;
    }

    function buyTokens() public payable {
        uint256 tokensToBuy = msg.value * (10 ** decimals()) / _tokenPrice;
        require(totalSupply() + tokensToBuy <= _maxSupply, "BooksToken: Exceeds max supply");
        _mint(msg.sender, tokensToBuy);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}