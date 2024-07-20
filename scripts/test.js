const hre = require("hardhat");

async function main() {
  const sponsorWalletBalanceTarget = ethers.utils.parseEther('0.100');
  const maxGasContribution = hre.ethers.utils.parseEther('0.001');

  const sponsorWallet = hre.ethers.Wallet.createRandom();
  const signers = await hre.ethers.getSigners();
  await signers[0].sendTransaction({
    to: sponsorWallet.address,
    value: hre.ethers.utils.parseEther('0.090'),
  });
  console.log(`Sponsor wallet balance target: ${hre.ethers.utils.formatEther(sponsorWalletBalanceTarget)} ETH`);
  console.log(`maxGasContribution: ${hre.ethers.utils.formatEther(maxGasContribution)} ETH`);
  console.log(`Sponsor wallet balance: ${hre.ethers.utils.formatEther(await hre.waffle.provider.getBalance(sponsorWallet.address))} ETH`);

  const MockRequester = await hre.ethers.getContractFactory("MockRequester");
  const mockRequester = await MockRequester.deploy(
    sponsorWallet.address,
    sponsorWalletBalanceTarget,
    maxGasContribution
  );

  for (let i = 0; i < 10; i++) {
    console.log(`Making request #${i}`);
    await mockRequester.makeRequest({ value: maxGasContribution });
    console.log(`Sponsor wallet balance: ${hre.ethers.utils.formatEther(await hre.waffle.provider.getBalance(sponsorWallet.address))} ETH`);
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
