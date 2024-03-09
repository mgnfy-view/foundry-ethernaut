/*
* Ethernaut Challenge 9
* King
* link: https://ethernaut.openzeppelin.com/level/0x3049C00639E6dfC269ED1451764a046f7aE500c6
*
* The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the 
* current prize becomes the new king. 
* On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process!
* Your goal is to break it.
* The deployer is going to reclaim kingship after you try to hack the contract. 
* You will beat the level if you can avoid such a self proclamation.
* 
* Use `../../test/09-King.t.sol` to attack the contract and write the solution
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}
