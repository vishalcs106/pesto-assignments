//deployment script for tykto platform

const hre = require("hardhat");

async function main() {
  const TyktoPlatform = await hre.ethers.getContractFactory("TyktoPlatform");
  const tyktoPlatform = await TyktoPlatform.deploy();

  await tyktoPlatform.deployed();

  console.log("TyktoPlatform deployed to:", tyktoPlatform.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
