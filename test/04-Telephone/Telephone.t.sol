// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Telephone } from "@src/04-Telephone/Telephone.sol";

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

        assertEq(telephone.owner(), attacker);
    }
}
