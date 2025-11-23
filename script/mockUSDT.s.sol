// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockUSDT} from "../src/mocks/mockUSDT.sol";

contract DeployMockUSDT is Script {

    MockUSDT public mockUsdt;

    function run() public {
      
      vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

      mockUsdt = new MockUSDT();

      vm.stopBroadcast();
    }
}
