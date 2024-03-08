/*
* Ethernaut Challenge 4
* Fallback
* link: https://ethernaut.openzeppelin.com/level/0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446
*
* Claim ownership of the contract `Telephone`
* 
* Use `../../test/04-Telephone.t.sol` to attack the contract and write the solution
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
