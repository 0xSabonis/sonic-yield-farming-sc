// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SwapProxy {
    address public owner;
    address public farmerContract;
    bool public initialized;
    
    constructor() {
        owner = msg.sender;
    }
    
    receive() external payable {}
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }
    
    modifier onlyFarmerContract() {
        require(msg.sender == farmerContract, "Not authorized");
        _;
    }
    
    function setFarmerContract(address _farmerContract) external onlyOwner {
        require(!initialized, "Already initialized");
        require(_farmerContract != address(0), "Invalid address");
        farmerContract = _farmerContract;
        initialized = true;
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }
    
    function sendETHToFarmer() external onlyFarmerContract {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH balance to send");
        
        (bool success, ) = payable(farmerContract).call{value: balance, gas: 50000}("");
        require(success, "ETH transfer failed");
    }
    
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance > 0) {
            (bool success, ) = payable(owner).call{value: balance}("");
            require(success, "ETH transfer failed");
        }
    }
}