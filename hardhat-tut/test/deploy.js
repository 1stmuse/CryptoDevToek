const { ethers } = require("hardhat");

import { CRYPTO_DEV_NFT_ADDRESS } from "../constants";

const main = async () => {
  const contract = await ethers.getContractFactory("CryptoDevToken");
  const CDTContract = await contract.deploy(CRYPTO_DEV_NFT_ADDRESS);

  //   await CDTContract.deployed(CRYPTO_DEV_NFT_ADDRESS);
  console.log("address", CDTContract.address);
};

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
