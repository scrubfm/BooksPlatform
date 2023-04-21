const { expect } = require("chai");
const { BN, ether, expectEvent, expectRevert } = require("@openzeppelin/test-helpers");

const BooksToken = artifacts.require("BooksToken");
const BooksNFT = artifacts.require("BooksNFT");

contract("BooksToken", (accounts) => {
  const [owner, user1] = accounts;
  const initialTokenPrice = ether("0.001");
  const initialSupply = ether("1000000000000"); // 1 trillion tokens

  beforeEach(async () => {
    this.booksToken = await BooksToken.new(initialTokenPrice, { from: owner });
    await this.booksToken.mint(owner, initialSupply, { from: owner });
  });

  // ... BooksToken tests ...

});

contract("BooksNFT", (accounts) => {
  const [owner, user1] = accounts;
  const mintCost = ether("0.01");

  beforeEach(async () => {
    this.booksNFT = await BooksNFT.new({ from: owner });
    await this.booksNFT.setMintCost(mintCost, { from: owner });
  });

  // ... BooksNFT tests ...

  it("should not allow a non-owner to burn an NFT", async () => {
    await this.booksNFT.mintNFT(owner, "https://example.com/token/1", { from: owner, value: mintCost });
    await expectRevert(
      this.booksNFT.burn("1", { from: user1 }),
      "Ownable: caller is not the owner"
    );
  });

  it("should allow the owner to pause and unpause the contract", async () => {
    await this.booksNFT.pause({ from: owner });
    await expectRevert(
      this.booksNFT.mintNFT(user1, "https://example.com/token/1", { from: user1, value: mintCost }),
      "Pausable: paused"
    );

    await this.booksNFT.unpause({ from: owner });
    const { logs } = await this.booksNFT.mintNFT(user1, "https://example.com/token/1", {
      from: user1,
      value: mintCost,
    });
    expectEvent.inLogs(logs, "Transfer", {
      from: "0x0000000000000000000000000000000000000000",
      to: user1,
      tokenId: new BN("1"),
    });
  });

  it("should not allow a non-owner to pause or unpause the contract", async () => {
    await expectRevert(this.booksNFT.pause({ from: user1 }), "Ownable: caller is not the owner");
    await expectRevert(this.booksNFT.unpause({ from: user1 }), "Ownable: caller is not the owner");
  });

  it("should allow the owner to add a new contract address", async () => {
    const newContractAddress = "0x1111111111111111111111111111111111111111";
    await this.booksNFT.addNewContract(newContractAddress, { from: owner });
    const storedNewContractAddress = await this.booksNFT.newContractAddress();
    expect(storedNewContractAddress).to.equal(newContractAddress);
  });

  it("should not allow a non-owner to add a new contract address", async () => {
    await expectRevert(
      this.booksNFT.addNewContract("0x1111111111111111111111111111111111111111", { from: user1 }),
      "Ownable: caller is not the owner"
    );
  });
});

