const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3Utils = require("web3-utils");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("OwnerControlGame", () => {
  let ownerControlGameInstance;
  
  beforeEach(async () => {
    const OwnerControlGame = await ethers.getContractFactory("OwnerControlGame");
    ownerControlGameInstance = await OwnerControlGame.deploy();
    await ownerControlGameInstance.deployed();
  });


});
