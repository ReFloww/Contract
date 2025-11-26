// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {FactoryP2P} from "../src/FactoryP2P.sol";
import {TokenP2P} from "../src/TokenP2P.sol";
import {MockUSDT} from "../src/mocks/mockUSDT.sol";

contract FactoryP2PTest is Test {
    FactoryP2P public factory;
    MockUSDT public usdt;
    address public owner = address(0x1);
    address public user = address(0x2);

    function setUp() public {
        usdt = new MockUSDT();
        factory = new FactoryP2P(address(usdt));
    }

    function testConstructor() public {
        assertEq(address(factory.usdtAddress()), address(usdt));
        address[] memory deployed = factory.getDeployedContracts();
        assertEq(deployed.length, 0);
    }

    function testCreateContract() public {
        address tokenAddress = factory.createContract("TestToken", "TEST", 1000000);

        assertTrue(tokenAddress != address(0));

        TokenP2P token = TokenP2P(tokenAddress);
        assertEq(token.name(), "TestToken");
        assertEq(token.symbol(), "TEST");
        assertEq(token.maxSupply(), 1000000);
    }

    function testCreateContractMultiple() public {
        address token1 = factory.createContract("Token1", "T1", 1000000);
        address token2 = factory.createContract("Token2", "T2", 2000000);

        assertTrue(token1 != token2);

        address[] memory deployed = factory.getDeployedContracts();
        assertEq(deployed.length, 2);
        assertEq(deployed[0], token1);
        assertEq(deployed[1], token2);
    }

    function testGetDeployedContracts() public {
        address[] memory deployed = factory.getDeployedContracts();
        assertEq(deployed.length, 0);

        factory.createContract("TestToken", "TEST", 1000000);

        deployed = factory.getDeployedContracts();
        assertEq(deployed.length, 1);
        assertTrue(deployed[0] != address(0));
    }

    function testCreateContractEvent() public {
      vm.expectEmit(true, false, false, true);
      
      emit FactoryP2P.ContractDeployed(1, address(0), 1000000, "TestToken", "TEST");

      address tokenAddress = factory.createContract("TestToken", "TEST", 1000000);

      assertTrue(tokenAddress != address(0), "Token should be deployed");
  }
}