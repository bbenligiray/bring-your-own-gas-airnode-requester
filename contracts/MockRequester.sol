//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

contract MockRequester {
    address public sponsorWalletAddress;
    uint256 public sponsorWalletBalanceTarget;
    uint256 public maxGasContribution;

    constructor(
        address _sponsorWalletAddress,
        uint256 _sponsorWalletBalanceTarget,
        uint256 _maxGasContribution
    ) public {
        sponsorWalletAddress = _sponsorWalletAddress;
        sponsorWalletBalanceTarget = _sponsorWalletBalanceTarget;
        maxGasContribution = _maxGasContribution;
    }

    // Use ReentrancyGuard or something equivalent
    function makeRequest() external payable {
        // We require at most maxGasContribution per request for the sake of fairness
        // If the user wants a guarantee for this not reverting, they can send maxGasContribution and receive a refund
        uint256 fundsToForward = sponsorWalletBalanceTarget > sponsorWalletAddress.balance
            ? maxGasContribution * (sponsorWalletBalanceTarget - sponsorWalletAddress.balance) / sponsorWalletBalanceTarget
            : 0;
        require(
            msg.value >= fundsToForward,
            "Not enough contribution for gas cost"
        );
        if (fundsToForward != 0) {
            (bool success, ) = sponsorWalletAddress.call{value: fundsToForward}("");
            require(success, "Forward failed");
        }
        // It's a better practice to let the user withdraw the refund with a separate tx but that's also bad UX
        uint256 fundsToRefund = msg.value - fundsToForward;
        if (fundsToRefund != 0) {
            (bool success, ) = msg.sender.call{value: fundsToRefund}("");
            require(success, "Refund failed");
        }
        // Proceed with making the request...
    }
}
