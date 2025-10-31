// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LiskGarden {

    // ============================================
    // BAGIAN 1: ENUM & STRUCT
    // ============================================
    // TODO 1.1: Buat enum GrowthStage
    enum GrowthStage { SEED, SPROUT, GROWING, BLOOMING }

    // TODO 1.2: Buat struct Plant
    struct Plant {
        uint256 id;
        address owner;
        GrowthStage stage;
        uint256 plantedDate;
        uint256 lastWatered;
        uint8 waterLevel;
        bool exists;
        bool isDead;
    }

    // ============================================
    // BAGIAN 2: STATE VARIABLES
    // ============================================
    // TODO 2.1: Mapping plantId ke Plant
    mapping(uint256 => Plant) public plants;

    // TODO 2.2: Mapping address ke array plantId
    mapping(address => uint256[]) public userPlants;

    // TODO 2.3: Counter untuk ID tanaman baru
    uint256 public plantCounter;

    // TODO 2.4: Address owner contract
    address public owner;

    // ============================================
    // BAGIAN 3: CONSTANTS (Game Parameters)
    // ============================================
    // TODO 3.1: Harga tanam
    uint256 public constant PLANT_PRICE = 0.001 ether;

    // TODO 3.2: Reward panen
    uint256 public constant HARVEST_REWARD = 0.003 ether;

    // TODO 3.3: Durasi per stage
    uint256 public constant STAGE_DURATION = 1 minutes;

    // TODO 3.4: Waktu deplesi air
    uint256 public constant WATER_DEPLETION_TIME = 30 seconds;

    // TODO 3.5: Rate deplesi
    uint8 public constant WATER_DEPLETION_RATE = 2;

    // ============================================
    // BAGIAN 4: EVENTS
    // ============================================
    // TODO 4.1: Event PlantSeeded
    event PlantSeeded(address indexed owner, uint256 indexed plantId);
    
    // TODO 4.2: Event PlantWatered
    event PlantWatered(uint256 indexed plantId, uint8 newWaterLevel);
    
    // TODO 4.3: Event PlantHarvested
    event PlantHarvested(uint256 indexed plantId, address indexed owner, uint256 reward);
    
    // TODO 4.4: Event StageAdvanced
    event StageAdvanced(uint256 indexed plantId, GrowthStage newStage);
    
    // TODO 4.5: Event PlantDied
    event PlantDied(uint256 indexed plantId);

    // ============================================
    // BAGIAN 5: CONSTRUCTOR
    // ============================================
    // TODO 5: Set owner = msg.sender
    constructor() {
        owner = msg.sender;
    }

    // ============================================
    // BAGIAN 6: PLANT SEED (Fungsi Utama #1)
    // ============================================
    // TODO 6: Lengkapi fungsi plantSeed
    function plantSeed() external payable returns (uint256) {
        // 1. require msg.value >= PLANT_PRICE
        require(msg.value >= PLANT_PRICE, "Not enough ETH to plant");

        // 2. Increment plantCounter
        plantCounter++;
        uint256 newPlantId = plantCounter;

        // 3. Buat Plant baru dengan struct
        // 4. Simpan ke mapping plants
        plants[newPlantId] = Plant({
            id: newPlantId,
            owner: msg.sender,
            stage: GrowthStage.SEED,
            plantedDate: block.timestamp,
            lastWatered: block.timestamp,
            waterLevel: 100, // Mulai dengan air penuh
            exists: true,
            isDead: false
        });

        // 5. Push plantId ke userPlants
        userPlants[msg.sender].push(newPlantId);

        // 6. Emit PlantSeeded
        emit PlantSeeded(msg.sender, newPlantId);

        // 7. Return plantId
        return newPlantId;
    }

    // ============================================
    // BAGIAN 7: WATER SYSTEM (3 Fungsi)
    // ============================================

    // TODO 7.1: calculateWaterLevel (public view returns uint8)
    function calculateWaterLevel(uint256 plantId) public view returns (uint8) {
        // 1. Ambil plant dari storage (sebagai memory)
        Plant memory plant = plants[plantId];

        // 2. Jika !exists atau isDead, return 0
        if (!plant.exists || plant.isDead) {
            return 0;
        }

        // 3. Hitung timeSinceWatered
        uint256 timeSinceWatered = block.timestamp - plant.lastWatered;
        
        // 4. Hitung depletionIntervals
        uint256 depletionIntervals = timeSinceWatered / WATER_DEPLETION_TIME;

        // 5. Hitung waterLost
        uint256 waterLost = depletionIntervals * WATER_DEPLETION_RATE;

        // 6. Jika waterLost >= waterLevel, return 0
        if (waterLost >= plant.waterLevel) {
            return 0;
        }

        // 7. Return waterLevel - waterLost (casting ke uint8)
        return uint8(plant.waterLevel - waterLost);
    }

    // TODO 7.2: updateWaterLevel (internal)
    function updateWaterLevel(uint256 plantId) internal {
        // 1. Ambil plant dari storage (sebagai pointer)
        Plant storage plant = plants[plantId];

        // 2. Hitung currentWater
        uint8 currentWater = calculateWaterLevel(plantId);

        // 3. Update plant.waterLevel
        plant.waterLevel = currentWater;

        // 4. Jika currentWater == 0 && !isDead, set isDead
        if (currentWater == 0 && !plant.isDead) {
            plant.isDead = true;
            emit PlantDied(plantId);
        }
    }

    // TODO 7.3: waterPlant (external)
    function waterPlant(uint256 plantId) external {
        // Ambil plant storage
        Plant storage plant = plants[plantId];

        // 1. require exists
        require(plant.exists, "Plant does not exist");
        
        // 2. require owner == msg.sender
        require(plant.owner == msg.sender, "Not your plant");
        
        // 3. require !isDead
        require(!plant.isDead, "Your plant is dead");

        // 4. Set waterLevel = 100
        plant.waterLevel = 100;
        
        // 5. Set lastWatered = block.timestamp
        plant.lastWatered = block.timestamp;

        // 6. Emit PlantWatered
        emit PlantWatered(plantId, 100);
        
        // 7. Call updatePlantStage
        updatePlantStage(plantId);
    }

    // ============================================
    // BAGIAN 8: STAGE & HARVEST (2 Fungsi)
    // ============================================

    // TODO 8.1: updatePlantStage (public)
    function updatePlantStage(uint256 plantId) public {
        // Ambil plant storage
        Plant storage plant = plants[plantId];

        // 1. require exists
        require(plant.exists, "Plant does not exist");

        // 2. Call updateWaterLevel
        updateWaterLevel(plantId);

        // 3. Jika isDead, return
        if (plant.isDead) {
            return;
        }

        // 4. Hitung timeSincePlanted
        uint256 timeSincePlanted = block.timestamp - plant.plantedDate;

        // 5. Simpan oldStage
        GrowthStage oldStage = plant.stage;

        // 6. Update stage berdasarkan waktu
        // (Logika if harus dari yang terbesar ke terkecil)
        if (timeSincePlanted >= STAGE_DURATION * 3) {
            plant.stage = GrowthStage.BLOOMING;
        } else if (timeSincePlanted >= STAGE_DURATION * 2) {
            plant.stage = GrowthStage.GROWING;
        } else if (timeSincePlanted >= STAGE_DURATION) {
            plant.stage = GrowthStage.SPROUT;
        }
        // else: tetap SEED (sudah default)

        // 7. Jika stage berubah, emit StageAdvanced
        if (oldStage != plant.stage) {
            emit StageAdvanced(plantId, plant.stage);
        }
    }

    // TODO 8.2: harvestPlant (external)
    function harvestPlant(uint256 plantId) external {
        // Ambil plant storage
        Plant storage plant = plants[plantId];
        
        // 1. require exists
        require(plant.exists, "Plant does not exist");
        
        // 2. require owner
        require(plant.owner == msg.sender, "Not your plant");
        
        // 3. require !isDead
        require(!plant.isDead, "Plant is dead");

        // 4. Call updatePlantStage (untuk memastikan data stage terbaru)
        updatePlantStage(plantId);

        // 5. require stage == BLOOMING
        // (Kita perlu cek ulang 'plant.stage' karena bisa jadi di-update)
        require(plants[plantId].stage == GrowthStage.BLOOMING, "Not yet blooming");

        // 6. Set exists = false (menghapus tanaman)
        plant.exists = false;

        // 7. Emit PlantHarvested
        emit PlantHarvested(plantId, msg.sender, HARVEST_REWARD);

        // 8. Transfer HARVEST_REWARD dengan .call
        (bool success, ) = msg.sender.call{value: HARVEST_REWARD}("");
        
        // 9. require success
        require(success, "Reward transfer failed");
    }

    // ============================================
    // HELPER FUNCTIONS (Sudah Lengkap)
    // ============================================

    function getPlant(uint256 plantId) external view returns (Plant memory) {
        Plant memory plant = plants[plantId];
        plant.waterLevel = calculateWaterLevel(plantId);
        return plant;
    }

    function getUserPlants(address user) external view returns (uint256[] memory) {
        return userPlants[user];
    }

    function withdraw() external {
        require(msg.sender == owner, "Bukan owner");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Transfer gagal");
    }

    receive() external payable {}
}