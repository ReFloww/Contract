// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {DeployTokenP2P} from "../script/DeployTokenP2P.s.sol";

contract DeployTokenP2PTest is Test {
    DeployTokenP2P deployer;

    function setUp() public {
        deployer = new DeployTokenP2P();
    }

    function testDeployTokenP2P() public {
        deployer.run();
    }
}