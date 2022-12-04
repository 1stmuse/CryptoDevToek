// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { CRYPTO_DEV_NFT_ADDRESS } = require("../constants");

async function main() {
  const conractFactory = await hre.ethers.getContractFactory("CryptoDevToken");
  const CryptoDevToken = await conractFactory.deploy(CRYPTO_DEV_NFT_ADDRESS);

  await CryptoDevToken.deployed();

  console.log(
    `Lock with 1 ETH and unlock ti deployed to ${CryptoDevToken.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
