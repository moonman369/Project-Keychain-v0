import { ethers } from "hardhat";
import { ContractAdapter } from "./adapters/contractAdapter";
import { ABI, CONTRACT_ADDRESS, RPC_URL } from "./contstants/constants";
import { getBytes } from "ethers";
import { getBytesString } from "./utils/miscUtils";

const operations = async () => {
  const [addr0, addr1, addr2, addr3] = (await ethers.getSigners()).map(
    (signer) => signer.address
  );
  // const signer = signers[0];
  const projectKeychainContract = new ContractAdapter(
    CONTRACT_ADDRESS,
    ABI,
    RPC_URL
  );

  console.log(getBytesString("hello"));

  await projectKeychainContract.createNewKeychainHolder(addr0, "genesis0");

  await projectKeychainContract.getKeychainHolderDetails(addr0);
};

const main = async () => {
  await operations();
};

main().catch((error) => {
  console.error(error);
});
