//deployment script for tykto platform

const hre = require("hardhat");

async function main() {
  const TyktoPlatform = await hre.ethers.getContractFactory("TyktoPlatform");
  const tyktoTokenAddress = "0xf03C02d3262E1F06525a5f6Bd7C9f1D367fE00F2";
  const tyktoPlatform = await TyktoPlatform.deploy(tyktoTokenAddress);

  await tyktoPlatform.deployed();

  console.log("TyktoPlatform deployed to:", tyktoPlatform.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
