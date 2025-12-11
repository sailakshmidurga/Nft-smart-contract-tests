const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftCollection", function () {
  let NftFactory;
  let nft;
  let owner, addr1, addr2;

  const NAME = "MyNFT";
  const SYMBOL = "MNFT";
  const MAX_SUPPLY = 5;
  const BASE = "https://example.com/meta";

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    NftFactory = await ethers.getContractFactory("NftCollection");
    nft = await NftFactory.deploy(NAME, SYMBOL, MAX_SUPPLY, BASE);

    // IMPORTANT for ethers v6
    await nft.waitForDeployment();
  });

  it("deploys correctly", async function () {
    expect(await nft.name()).to.equal(NAME);
    expect(await nft.symbol()).to.equal(SYMBOL);
    expect(await nft.maxSupply()).to.equal(MAX_SUPPLY);
    expect(await nft.totalSupply()).to.equal(0);
  });

  it("owner can mint", async function () {
    await nft.safeMint(addr1.address, 1);
    expect(await nft.ownerOf(1)).to.equal(addr1.address);
    expect(await nft.totalSupply()).to.equal(1);
  });

  it("non-owner cannot mint", async function () {
    await expect(
      nft.connect(addr1).safeMint(addr1.address, 1)
    ).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("tokenURI works", async function () {
    await nft.safeMint(owner.address, 1);
    expect(await nft.tokenURI(1)).to.equal(`${BASE}/1.json`);
  });

  it("pause blocks mint and transfer", async function () {
    await nft.safeMint(owner.address, 1);
    await nft.pause();

    await expect(
      nft.safeMint(owner.address, 2)
    ).to.be.revertedWith("Pausable: paused");

    await expect(
      nft.transferFrom(owner.address, addr1.address, 1)
    ).to.be.revertedWith("Pausable: paused");
  });
});
