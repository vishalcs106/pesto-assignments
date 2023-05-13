//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const tyktoNftAddress = "0x6601083C62868257ED5Ea8F96a4d0F01b13aE3AC";
  const tyktoTokenAddress = "0x6f509D15615cFe5DAf5756a5575D21Ec67B1Df7b";
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
