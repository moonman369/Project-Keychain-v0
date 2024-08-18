import { ethers } from "ethers";

export function getBytesString(input: string) {
  //   return ethers.hexlify(input);
  const hexString = Buffer.from(input, "utf8").toString("hex");
  return `0x${hexString}`;
}
