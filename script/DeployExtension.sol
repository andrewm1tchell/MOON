// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IAWYAExtension} from "../src/IAWYAExtension.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract DeployExtension is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address flipEngineAddress = 0x457b961794d9F1037C63c3dd09E588Cb93567FAa;


        vm.startBroadcast(deployerPrivateKey);
        IAWYAExtension extension = new IAWYAExtension(
            flipEngineAddress
        );

        FlipEngine flipEngine = FlipEngine(flipEngineAddress);

        flipEngine.grantAccess(address(extension));
    
        console.log("Extension deployed to:", address(extension));
    
        vm.stopBroadcast();
    }
}