const hre = require("hardhat");

async function main() {
  const stream = await hre.ethers.deployContract('AjiraPayFinanceTokenStreamVault');

  await stream.waitForDeployment();
  
  console.log("Ajira Pay Finance Stream Vault on Polygon POS mainnet deployed to:", stream.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
