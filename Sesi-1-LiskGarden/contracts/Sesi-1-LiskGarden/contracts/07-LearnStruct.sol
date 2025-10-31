// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnStruct {
    enum GrowthStage {SEED,SPROUD,GROWING,BLOOMING}

    struct Plant{
        uint256 id;
        address owner;
        GrowthStage stage;
        uint8 waterLevel;
        bool isAlive;
    }

    Plant public myplant;

    constructor() {
        myplant = Plant({
            id: 1,
            owner: msg.sender,
            stage: GrowthStage.SEED,
            waterLevel: 100,
            isAlive: true
        });
    }

    function setWater() public {
        myplant.waterLevel = 100;
    }

    function growth() public {
        if(myplant.stage == GrowthStage.SEED) {
            myplant.stage = GrowthStage.SPROUD;
        }
    }
}

