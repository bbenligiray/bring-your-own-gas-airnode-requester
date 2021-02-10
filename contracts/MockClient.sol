//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;


contract MockClient {
    address public designatedWalletAddress;
    uint256 public designatedWalletBalanceTarget;
    uint256 public maxGasContribution;
    
    constructor (
        address _designatedWalletAddress,
        uint256 _designatedWalletBalanceTarget,
        uint256 _maxGasContribution
        )
        public
    {
        designatedWalletAddress = _designatedWalletAddress;
        designatedWalletBalanceTarget = _designatedWalletBalanceTarget;
        maxGasContribution = _maxGasContribution;
    }

    function makeRequest()
        external
        payable
    {
        require(msg.value >= maxGasContribution, "Not enough contribution for gas cost");
        uint256 fundsToReturn;
        if (designatedWalletAddress.balance < designatedWalletBalanceTarget)
        {
            // This logic can be customized
            fundsToReturn = msg.value * (designatedWalletBalanceTarget - designatedWalletAddress.balance) / designatedWalletBalanceTarget;
            fundsToReturn = fundsToReturn > maxGasContribution ? maxGasContribution : fundsToReturn;
        }
        else
        {
            fundsToReturn = msg.value;
        }
        if (fundsToReturn != 0)
        {
            (bool success, ) = msg.sender.call{ value: fundsToReturn }("");
            require(success, "Refund failed");
        }
        uint256 fundsToForward = msg.value - fundsToReturn;
        if (fundsToForward != 0)
        {
            (bool success, ) = designatedWalletAddress.call{ value: fundsToForward }("");
            require(success, "Forward failed");
        }
        // Proceed with making the request...
    }
}
