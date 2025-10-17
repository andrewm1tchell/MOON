// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MoonExtension} from "../src/MoonExtension.sol";

contract Mint is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address extensionAddress = 0x2F794e3d36Ca796291815FB43F1FF424bf9223dF;
        address wallet = 0xF1Da6E2d387e9DA611dAc8a7FC587Eaa4B010013;
        uint256 tokenId = 27;

        vm.startBroadcast(deployerPrivateKey);
        
        // Create an instance of the contract using the interface
        MoonExtension extension = MoonExtension(extensionAddress);
        
        // Call the functions directly
        extension.mint(wallet);
        console.log("Minted token to:", wallet);
        
        extension.setTokenId(tokenId);
        console.log("Set token ID to:", tokenId);
        
        vm.stopBroadcast();
    }
}