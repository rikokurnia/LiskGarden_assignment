// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SimplePlant {
    string public plantName;
    uint256 public waterLevel;
    bool public isAlive;
    address public owner;
    uint256 public plantedTime;

    constructor() {
        plantName = "Rose";
        waterLevel = 100;
        isAlive = true;
        owner = msg.sender;
        plantedTime = block.timestamp;
    }

    function water() public {
        waterLevel = 100;
    }
    function getAge() public view returns(uint256) {
        return block.timestamp - plantedTime;
    }
}