// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract FlipEngineScript is Script {
    // The deployed FlipEngine contract address on Sepolia
    address constant FLIP_ENGINE_ADDRESS = 0x8f8d99244E910CE59d092e16421E52fc48770D60;
    
    function setUp() public {}

    function run() public {
        // Load your private key from environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);
        
        // Get the FlipEngine contract instance
        FlipEngine flipEngine = FlipEngine(FLIP_ENGINE_ADDRESS);
        
        // Read and add first image chunks
        string memory firstImagePath = "src/1.txt";
        string memory firstImageContent = vm.readFile(firstImagePath);
        
        // Split into chunks of 1000 characters (adjust this size based on Sepolia's limits)
        uint256 chunkSize = 1000;
        uint256 contentLength = bytes(firstImageContent).length;
        
        // Add first image chunks
        for(uint256 i = 0; i < contentLength; i += chunkSize) {
            uint256 end = i + chunkSize;
            if(end > contentLength) {
                end = contentLength;
            }
            string memory chunk = substring(firstImageContent, i, end);
            flipEngine.addFirstImageChunk(chunk);
            console.log("Added first image chunk %d/%d", end, contentLength);
        }
        
        // Read and add second image chunks
        string memory secondImagePath = "src/2.txt";
        string memory secondImageContent = vm.readFile(secondImagePath);
        contentLength = bytes(secondImageContent).length;
        
        // Add second image chunks
        for(uint256 i = 0; i < contentLength; i += chunkSize) {
            uint256 end = i + chunkSize;
            if(end > contentLength) {
                end = contentLength;
            }
            string memory chunk = substring(secondImageContent, i, end);
            flipEngine.addSecondImageChunk(chunk);
            console.log("Added second image chunk %d/%d", end, contentLength);
        }
        
        vm.stopBroadcast();
    }
    
    // Helper function to get substring
    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for(uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}