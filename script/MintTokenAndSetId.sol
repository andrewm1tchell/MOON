// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IAWYAExtension} from "../src/IAWYAExtension.sol";

contract Mint is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address extensionAddress = 0x471712732542Ea2b3BB0a7da11B865E328d65E99;
        address wallet = 0xF1Da6E2d387e9DA611dAc8a7FC587Eaa4B010013;
        uint256 tokenId = 19;

        vm.startBroadcast(deployerPrivateKey);
        
        // Create an instance of the contract using the interface
        IAWYAExtension extension = IAWYAExtension(extensionAddress);
        
        // Call the functions directly
        extension.mint(wallet);
        console.log("Minted token to:", wallet);
        
        extension.setTokenId(tokenId);
        console.log("Set token ID to:", tokenId);
        
        vm.stopBroadcast();
    }
}