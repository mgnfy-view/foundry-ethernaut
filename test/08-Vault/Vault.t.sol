// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "forge-std/Test.sol";
import { Vault } from "@src/08-Vault/Vault.sol";

contract HackVault is Test {
    Vault public vault;
    address public deployer;
    address public attacker;

    function setUp() public {
        deployer = makeAddr("deployer");
        attacker = makeAddr("attacker");

        vm.prank(deployer);
        // don't look here!
        vault = new Vault(bytes32("Secret!"));
    }

    function testUnlockTheVault() public {
        // hack the contract
        // your code goes here

        assertEq(vault.locked(), false);
    }
}
