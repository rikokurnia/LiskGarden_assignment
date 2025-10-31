// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnEnum {
    enum GrowthStage {
        SEED,
        SPROUD,
        GROWTH,
        BLOOM
    }

    GrowthStage public currentStage;

    constructor() {
        currentStage = GrowthStage.SEED;
    }

    function grow() public {
        if(currentStage == GrowthStage.SEED) {
            currentStage = GrowthStage.SPROUD; 
        }
        else if(currentStage == GrowthStage.SPROUD) {
            currentStage = GrowthStage.GROWTH; 
        }
        else if(currentStage == GrowthStage.GROWTH) {
            currentStage = GrowthStage.BLOOM; 
        }
    }
}