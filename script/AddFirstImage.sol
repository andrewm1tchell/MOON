// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IAWYAExtension} from "../src/IAWYAExtension.sol";

contract AddFirstImage is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Hardcoded contract address
        address deployedAddress = 0xB1fe03cC25B2EefB01f441E72f3cCb5DF667Bd0E;
        IAWYAExtension extension = IAWYAExtension(deployedAddress);
        
        string memory firstImagePath = "src/1.txt";
        string memory firstImageContent = vm.readFile(firstImagePath);
        
        uint256 chunkSize = 1000;
        uint256 contentLength = bytes(firstImageContent).length;
        console.log("First image length:", contentLength);
        
        vm.startBroadcast(deployerPrivateKey);
        
        uint256 chunkIndex = 0;
        for(uint256 i = 0; i < contentLength; i += chunkSize) {
            uint256 end = i + chunkSize;
            if(end > contentLength) {
                end = contentLength;
            }
            string memory chunk = substring(firstImageContent, i, end);
            console.log("Adding first image chunk %d/%d", chunkIndex, contentLength);
            
            extension.addFirstImageChunk(chunkIndex, chunk);
            chunkIndex++;
        }
        
        vm.stopBroadcast();
    }
    
    function substring(string memory str, uint256 startIndex, uint256 endIndex) private pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for(uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}