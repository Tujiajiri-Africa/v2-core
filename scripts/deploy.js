const hre = require("hardhat");

async function main() {
  const stream = await hre.ethers.deployContract('AjiraPayFinanceTokenStreamingVault');

  await stream.waitForDeployment();
  
  console.log("Ajira Pay Finance Tocken Lockup on Linea Testnet deployed to:", stream.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
