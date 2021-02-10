const hre = require("hardhat");

async function main() {
  const designatedWalletBalanceTarget = ethers.utils.parseEther('0.1');
  const maxGasContribution = hre.ethers.utils.parseEther('0.001');

  // Create a designated wallet
  const designatedWallet = hre.ethers.Wallet.createRandom();
  // Fund it with 0.09 ETH
  const signers = await hre.ethers.getSigners();
  await signers[0].sendTransaction({
    to: designatedWallet.address,
    value: hre.ethers.utils.parseEther('0.09'),
  });
  console.log(`Designated wallet balance: ${hre.ethers.utils.formatEther(await hre.waffle.provider.getBalance(designatedWallet.address))} ETH`);

  const MockClient = await hre.ethers.getContractFactory("MockClient");
  const mockClient = await MockClient.deploy(
    designatedWallet.address,
    designatedWalletBalanceTarget,
    maxGasContribution
  );

  for (let i = 0; i < 10; i++) {
    console.log(`Making request #${i}`);
    const gasCost = await mockClient.estimateGas.makeRequest({ value: maxGasContribution });
    await mockClient.makeRequest({ value: maxGasContribution });
    console.log(`Contribution cost ${gasCost.toString()} gas`);
    console.log(`Designated wallet balance: ${hre.ethers.utils.formatEther(await hre.waffle.provider.getBalance(designatedWallet.address))} ETH`);
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
