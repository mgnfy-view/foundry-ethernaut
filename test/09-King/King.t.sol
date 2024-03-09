// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { King } from "@src/09-King/King.sol";

contract HackKing is Test {
    King public king;
    address public deployer;
    address public attacker;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        vm.deal(deployer, 1 ether);
        king = new King{ value: 1 ether }();
    }

    function testBecomeTheKing() public {
        // hack the contract
        // your code goes here

        assert(king._king() != deployer);
        vm.expectRevert();
        vm.prank(deployer);
        (bool proclamationSuccess,) = address(king).call{ value: 0 ether }("");
    }
}
