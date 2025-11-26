// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TokenP2P} from "./TokenP2P.sol";

contract FactoryP2P {
    address[] public deployedContracts;
    uint counterId = 1;
    
    address public immutable usdtAddress;

    event ContractDeployed(uint indexed contractId, address indexed contractAddress, uint maxSupply, string name, string symbol);

    constructor(address _usdtAddress) {
        usdtAddress = _usdtAddress;
    }

    function createContract(string memory name, string memory symbol, uint maxSupply) external returns (address) {
        TokenP2P newToken = new TokenP2P(name, symbol, maxSupply, usdtAddress);
        
        address newContractAddr = address(newToken);
        deployedContracts.push(newContractAddr);
        
        emit ContractDeployed(counterId, newContractAddr, maxSupply, name, symbol);
        counterId++;
        
        return newContractAddr;
    }

    function getDeployedContracts() external view returns (address[] memory) {
        return deployedContracts;
    }
}