// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IAWYAExtension} from "../src/IAWYAExtension.sol";

contract DeployExtension is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address creator = 0x11F99A29eE9C18FCC48Ff1dF4Ce931222c6301fc;
        address flipEngine = 0xb07Db852819E065f842c699772Be912314a1b742;

        vm.startBroadcast(deployerPrivateKey);
        IAWYAExtension extension = new IAWYAExtension(
            creator,
            "I Am Where You Aren't",
            "Description LALALALALA",
            flipEngine
        );
        
        console.log("Extension deployed to:", address(extension));
    
        vm.stopBroadcast();
    }
}