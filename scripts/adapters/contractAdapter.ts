import { ethers } from "ethers";
import * as dotenv from "dotenv";
import { ExecException } from "child_process";
import { getBytesString } from "../utils/miscUtils";
dotenv.config();

export class ContractAdapter {
  private PRIVATE_KEY = process.env.PRIVATE_KEY_LOCAL;
  private contract: ethers.Contract;
  private provider: ethers.JsonRpcProvider;
  private signer: ethers.Wallet;

  constructor(
    contractAddress: string,
    abi: any,
    rpcUrl: string
    // signer: ethers.Wallet
  ) {
    this.provider = new ethers.JsonRpcProvider(rpcUrl);

    this.signer = new ethers.Wallet(this.PRIVATE_KEY as string, this.provider);
    // this.signer = signer;

    if (this.signer) {
      this.contract = new ethers.Contract(contractAddress, abi, this.signer);
    } else {
      this.contract = new ethers.Contract(contractAddress, abi, this.provider);
    }
  }

  public async createNewKeychainHolder(
    holderAddress: string,
    holderUsername: string
  ) {
    try {
      const createNewKeychainHolder: ethers.ContractMethod = this.contract
        .connect(this.signer)
        .getFunction("createNewKeychainHolder");

      const holderUsernameBytes = getBytesString(holderUsername);

      const tx = await createNewKeychainHolder(
        holderAddress,
        holderUsernameBytes
      );

      const txResult = await tx.wait();
      console.log(txResult);
    } catch (error) {
      console.error(error);
    }
  }

  public async getKeychainHolderDetails(
    keychainHolderAddress: string
  ): Promise<any> {
    try {
      const getKeychainHolderDetails: ethers.ContractMethod = this.contract
        .connect(this.signer)
        .getFunction("getKeychainHolderDetails");

      const keychainHolderDetailsResult = await getKeychainHolderDetails(
        keychainHolderAddress
      );
      console.log(keychainHolderDetailsResult);
      return keychainHolderDetailsResult;
    } catch (error: any) {
      console.error(error);
    }
  }
}
