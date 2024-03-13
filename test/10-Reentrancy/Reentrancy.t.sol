// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Test } from "forge-std/Test.sol";
import { Reentrance } from "@src/10-Reentrancy/Reentrancy.sol";

contract ReEnter is Test {
    Reentrance public reEnter;
    address public deployer;
    address public attacker;
    address public naivePerson;
    uint256 constant DEPLOYER_STARTING_BALANCE = 1.3 ether;
    uint256 constant NAIVE_PERSON_STARTING_BALANCE = 2.8 ether;
    uint256 constant ATTACKER_STARTING_BALANCE = 0.5 ether;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");
        naivePerson = makeAddr("naivePerson");

        vm.prank(deployer);
        reEnter = new Reentrance();

        vm.deal(deployer, DEPLOYER_STARTING_BALANCE);
        vm.deal(naivePerson, NAIVE_PERSON_STARTING_BALANCE);
        vm.deal(attacker, ATTACKER_STARTING_BALANCE);

        vm.prank(deployer);
        reEnter.donate{ value: DEPLOYER_STARTING_BALANCE }(deployer);
        vm.prank(naivePerson);
        reEnter.donate{ value: NAIVE_PERSON_STARTING_BALANCE }(naivePerson);
    }

    function testStealAllTheMoney() public {
        // hack the contract
        // your code goes here

        assertEq(address(reEnter).balance, 0);
        assertEq(
            attacker.balance, DEPLOYER_STARTING_BALANCE + NAIVE_PERSON_STARTING_BALANCE + ATTACKER_STARTING_BALANCE
        );
    }
}
