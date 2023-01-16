import { ethers, network, run } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const ReputationContractFactory = await ethers.getContractFactory(
    "ReputationTokenFactory"
  );
  const reputationContractFactory = await ReputationContractFactory.deploy();

  await reputationContractFactory.deployed();

  await reputationContractFactory.initialize(deployer.address);

  if (network.config.chainId !== 31337) {
    // Wait for block confirmations to confirm the deployment
    // and verify on Etherscan
    const WAIT_BLOCK_CONFIRMATIONS = 6;
    await reputationContractFactory.deployTransaction.wait(
      WAIT_BLOCK_CONFIRMATIONS
    );
  }

  console.log(
    `Reputation Contract Factory successfully deployed to ${reputationContractFactory.address}`
  );

  // Only verify contract if not running on Hardhat network
  if (network.config.chainId !== 31337) {
    console.log(`Verifying contract on Etherscan...`);

    await run(`verify:verify`, {
      address: reputationContractFactory.address,
      constructorArguments: [],
    });
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
