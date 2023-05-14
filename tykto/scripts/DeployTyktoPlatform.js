//deployment script for tykto platform

const hre = require("hardhat");

async function main() {
  const TyktoPlatform = await hre.ethers.getContractFactory("TyktoPlatform");
  const tyktoTokenAddress = "0x4Df3F8F71e1aB54524BFd223024680867D432acb";
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
