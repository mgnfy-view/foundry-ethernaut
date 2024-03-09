// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/Script.sol";
import { Vault } from "@src/08-Vault/Vault.sol";

contract DeployVault is Script {
    function run() external {
        // use one of the default private keys that comes with anvil
        vm.startBroadcast(uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));
        Vault vault = new Vault(bytes32("Secret!"));
        vm.stopBroadcast();
    }
}
