// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {DeployFactoryP2P} from "../script/DeployFactoryP2P.s.sol";

contract DeployFactoryP2PTest is Test {
    DeployFactoryP2P deployer;

    function setUp() public {
        deployer = new DeployFactoryP2P();
    }

    function testDeployFactoryP2P() public {
        deployer.run();
    }
}