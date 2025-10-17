// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MoonExtension} from "../src/MoonExtension.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract DeployExtension is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        //address flipEngineAddress = 0x457b961794d9F1037C63c3dd09E588Cb93567FAa;
        address flipEngineAddress = 0x05EC1c0D5D8B2A3bAAb1CD84Bd822EDaa4ce074f;


        vm.startBroadcast(deployerPrivateKey);
        MoonExtension extension = new MoonExtension(
            flipEngineAddress
        );

        FlipEngine flipEngine = FlipEngine(flipEngineAddress);

        flipEngine.grantAccess(address(extension));

        extension.setCreator(0xfdA33af4770D844DC18D8788C7Bf84accfac79aD);
    
        console.log("Extension deployed to:", address(extension));
    
        vm.stopBroadcast();
    }
}