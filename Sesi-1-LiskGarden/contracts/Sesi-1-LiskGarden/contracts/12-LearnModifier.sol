// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract LearnModifier {
    mapping(uint256 => address) public plantOwner;
    mapping(uint256 => uint8) public waterLevel;
    address public owner;

     
    constructor(){
        owner = msg.sender;
    }

    modifier onlyPlantOwner(uint256 _plantId)  {
        require(plantOwner[_plantId] == owner, "Bukan pemilik tanaman!");
        _;
    }
   
    function addPlant(uint256 _plantId) public {
        plantOwner[_plantId] = msg.sender;
        waterLevel[_plantId] = 100;
    }

    function waterPlant(uint256 _plantId) public onlyPlantOwner(_plantId){
                waterLevel[_plantId] = 100;
    }
}