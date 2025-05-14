// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IAWYAExtension} from "../src/IAWYAExtension.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract DeployExtension is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address creator = 0x11F99A29eE9C18FCC48Ff1dF4Ce931222c6301fc;
        address flipEngineAddress = 0x5fa41D52B044ebD0a9Eda3cdbB75eAE61C1dd345;


        vm.startBroadcast(deployerPrivateKey);
        IAWYAExtension extension = new IAWYAExtension(
            creator,
            "I Am Where You Aren't",
            "Description LALALALALA",
            flipEngineAddress
        );

        FlipEngine flipEngine = FlipEngine(flipEngineAddress);

        flipEngine.grantAccess(address(extension));
    
        console.log("Extension deployed to:", address(extension));
    
        vm.stopBroadcast();
    }
}