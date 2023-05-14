//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const tyktoNftAddress = "0x1f4a122641A38EBeeb78d5A205A6acec9E678E27";
  const tyktoTokenAddress = "0xf03C02d3262E1F06525a5f6Bd7C9f1D367fE00F2";
  const TyktoMart = await hre.ethers.getContractFactory("TyktoMart");
  const tyktoMart = await TyktoMart.deploy(tyktoNftAddress, tyktoTokenAddress);

  await tyktoMart.deployed();

  console.log("TyktoMart deployed to:", tyktoMart.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
