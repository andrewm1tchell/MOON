// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract DeployFlipEngine is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        FlipEngine flipEngine = new FlipEngine();
    
        vm.stopBroadcast();
    }
}