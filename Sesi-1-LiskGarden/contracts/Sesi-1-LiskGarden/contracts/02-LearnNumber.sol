// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnNumber {
uint256 public plantId;
uint256 public waterLevel;

    constructor() {
        plantId = 1;
        waterLevel = 100;
    }

    function changePlantId(uint256 _newid) public {
        plantId = _newid;
    }

    function changeWaterLevel() public {
        waterLevel += 10;
    }

}

