// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test } from "forge-std/Test.sol";
import { Fallback } from "@src/01-Fallback/Fallback.sol";

contract HackFallback is Test {
    address public deployer;
    address public attacker;
    Fallback public fallbackContract;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        fallbackContract = new Fallback();
    }

    function testClaimOwnershipOfFallbackAndReduceBalanceToZero() public {
        // hack the contract
        // your code goes here

        assertEq(fallbackContract.owner(), attacker);
        assertEq(address(fallbackContract).balance, 0);
    }
}
