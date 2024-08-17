import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LockModule = buildModule("ProjectKeychainModule", (m) => {
  const ARCHITECT_LOCAL = m.getAccount(0);
  const architect = m.getParameter("architect", ARCHITECT_LOCAL);

  const projectKeychainContract = m.contract("ProjectKeychain0", [architect]);

  console.log("Preparing Ignition sequence... ⏱\n");

  return { projectKeychainContract };
});

export default LockModule;
