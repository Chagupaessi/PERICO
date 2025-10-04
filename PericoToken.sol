// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PericoToken is ERC20, Ownable {
    uint256 public maxSupply = 21000000 * 10 ** decimals();
    uint256 public currentSupply;
    uint256 public reward = 10500000 * 10 ** decimals(); // Primera emisión
    uint256 public halvingInterval = 126144000; // 4 años en segundos
    uint256 public nextHalving;
    uint8 public halvingCount;

    constructor() ERC20("Perico", "PERICO") Ownable(msg.sender) {
        nextHalving = block.timestamp + halvingInterval;
        _mint(msg.sender, reward);
        currentSupply += reward;
        halvingCount = 1;
    }

    function claimReward() external onlyOwner {
        require(block.timestamp >= nextHalving, "Halving not reached yet");
        require(currentSupply < maxSupply, "Max supply reached");

        reward = reward / 2;
        nextHalving = block.timestamp + halvingInterval;
        halvingCount += 1;

        uint256 mintAmount = reward;
        if (currentSupply + mintAmount > maxSupply) {
            mintAmount = maxSupply - currentSupply;
        }

        _mint(msg.sender, mintAmount);
        currentSupply += mintAmount;
    }
}