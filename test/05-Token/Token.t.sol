// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { Test } from "forge-std/Test.sol";
import { Token } from "@src/05-Token/Token.sol";

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

        assert(token.balanceOf(attacker) > 20e18);
    }
}
