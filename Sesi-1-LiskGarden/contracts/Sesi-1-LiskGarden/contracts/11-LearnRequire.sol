// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnRequire{
  mapping(uint256 => address) public plantOwner;
  mapping(uint256 => uint8) public waterLevel;

    function addPlant(uint256 _plantId) public {
        plantOwner[_plantId] = msg.sender;
        waterLevel[_plantId] = 100;
    }

    function waterPlant(uint256 _plantId) public {
        require(plantOwner[_plantId] ==  msg.sender, "Bukan Tanaman anda!");
        waterLevel[_plantId] = 100;
    }
}


