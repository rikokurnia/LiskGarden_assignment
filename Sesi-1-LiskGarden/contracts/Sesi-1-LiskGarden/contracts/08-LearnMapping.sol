// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnMapping{
    mapping(uint256 => uint8) public plantWater;
    mapping(uint256 => address) public plantOwner;

    function addPlant(uint256 _plantId) public {
        plantWater[_plantId] = 100;
        plantOwner[_plantId] = msg.sender;
    }

    function waterPlant(uint256 _plantId) public  {
        plantWater[_plantId] = 100;
    }
}