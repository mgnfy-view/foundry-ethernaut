// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Force } from "@src/07-Force/Force.sol";

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

        assert(address(force).balance > 0);
    }
}
