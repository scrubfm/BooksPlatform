const BooksToken = artifacts.require("BooksToken");
const BooksNFT = artifacts.require("BooksNFT");
const BooksPlatform = artifacts.require("BooksPlatform");

module.exports = async function (deployer, network, accounts) {
  // Deploy BooksToken
  const initialTokenPrice = 1000000000000000; // Set initial token price to 0.001 ETH
  await deployer.deploy(BooksToken, initialTokenPrice);
  const booksToken = await BooksToken.deployed();

  // Deploy BooksNFT
  await deployer.deploy(BooksNFT);
  const booksNFT = await BooksNFT.deployed();

  // Deploy BooksPlatform
  const burnCost = 1000000000; // BurnCost to mint NFT set at 1 Billion Books
  await deployer.deploy(BooksPlatform, booksToken.address, booksNFT.address, burnCost);
  const booksPlatform = await BooksPlatform.deployed();

  // Mint some initial Books tokens to the deployer's address
  const initialTokenSupply = 1000000000000; // mints 1 trillion books tokens to the deployer.
  await booksToken.mint(accounts[0], initialTokenSupply);
};