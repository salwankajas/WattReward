// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChargingStation {

    event ChargingEnded(address evAddress, address csAddress, uint256 slotIndex, uint256 chargeRate, uint256 duration,uint256 cost,uint256 startTime,uint256 endTime);
    

    struct ChargingSlot {
        uint256 startTime;
        uint256 endTime;
    }
    address public owner;
    uint public unitRate;

    mapping(address => mapping(uint256 => ChargingSlot)) public chargingSlots;

    constructor(uint _unitRate) {
        owner = msg.sender;
        unitRate = _unitRate;
    }


    // Modifier to ensure only CS or EV can call specific functions
    modifier onlyParties(address csAddress) {
        require(msg.sender == csAddress, "Only CS or EV can call this function");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    // Function to change the unitRate
    function setUnitRate(uint _unitRate) public onlyOwner {
        unitRate = _unitRate;
    }

    // Function called by CS to start charging process for a specific slot
    function startChargingApp(uint256 slotIndex) external onlyParties(msg.sender){
        require(chargingSlots[msg.sender][slotIndex].startTime == 0, "Charging has already started for this slot");
        chargingSlots[msg.sender][slotIndex] = ChargingSlot(block.timestamp, 0);

    }

    // Function called by CS to end charging process for a specific slot
    function endCharging(address evAddress, uint256 slotIndex,uint256 chargeRate,uint256 cost) external onlyParties(msg.sender){
        chargingSlots[msg.sender][slotIndex].endTime = block.timestamp;
        emit ChargingEnded(evAddress, msg.sender, slotIndex, chargeRate, chargingSlots[msg.sender][slotIndex].endTime - chargingSlots[msg.sender][slotIndex].startTime,cost,chargingSlots[msg.sender][slotIndex].startTime,chargingSlots[msg.sender][slotIndex].endTime);
        chargingSlots[msg.sender][slotIndex].startTime = 0;
    }

    function estimateChargingCost(uint256 chargingRate, uint256 duration) public view returns (uint256) {
        uint256 chargingAmount = chargingRate * duration;
        uint256 chargingCost = chargingAmount * unitRate;
        return chargingCost + (chargingCost*2)/10 ;
    }
}