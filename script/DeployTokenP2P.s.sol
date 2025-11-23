// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {TokenP2P} from "../src/TokenP2P.sol";

contract DeployTokenP2P is Script {

    TokenP2P public tokenP2P;
    uint maxSupply = 1000000 * 10**6;
    address USDT_ADDRESS = 0xe01c5464816a544d4d0d6a336032578bd4629F10;

    function run() public {
      
      vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

      tokenP2P = new TokenP2P("Token P2P","TP2P", maxSupply, USDT_ADDRESS);

      vm.stopBroadcast();
    }
}
