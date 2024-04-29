const hre = require("hardhat");

async function main() {
  const STREAM_CONTRACT_ADDRESS = "0xD2AA294B9A5097F4A09fd941eD0bE665bd85Eab2"
  const batchStream = await hre.ethers.deployContract('BatchStreamer',[STREAM_CONTRACT_ADDRESS],{});

  await batchStream.waitForDeployment();
  
  console.log("Ajira Pay Finance Stream Vault deployed to:", batchStream.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
