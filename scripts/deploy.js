const hre = require("hardhat");

async function main() {
  const STREAM_CONTRACT_ADDRESS = "0xC64263285867A40A1fE9121DB57ECddaa55cab06"
  const batchStream = await hre.ethers.deployContract('BatchStreamer',[STREAM_CONTRACT_ADDRESS],{});

  await batchStream.waitForDeployment();
  
  console.log("Ajira Pay Finance Batch Stream Vault on OP Mainnet deployed to:", batchStream.target);

  // const streamContract = await hre.ethers.deployContract('AjiraPayFinanceTokenStreamVault');

  // await streamContract.waitForDeployment();

  // console.log("Ajira Pay Finance Stream Vault on optimism mainnet deployed to:", streamContract.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
