// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Test } from "forge-std/Test.sol";
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

        assertEq(falloutContract.owner(), attacker);
    }
}
