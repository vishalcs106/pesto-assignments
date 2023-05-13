//deployment script for tykto mart

const hre = require("hardhat");

async function main() {

    const tyktoNftAddress = ""
    const tyktoTokenAddress = ""
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