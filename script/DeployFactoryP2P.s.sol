// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {TokenP2P} from "../src/TokenP2P.sol";
import {FactoryP2P} from "../src/FactoryP2P.sol";

contract DeployFactoryP2P is Script {

    FactoryP2P public factoryP2P;
    address USDT_ADDRESS = 0xe01c5464816a544d4d0d6a336032578bd4629F10;

    function run() public {
      
      vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

      factoryP2P = new FactoryP2P(USDT_ADDRESS);

      vm.stopBroadcast();
    }
}
