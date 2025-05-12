// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IAWYAExtension} from "../src/IAWYAExtension.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract AddFirstImage is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Hardcoded contract address
        address deployedAddress = 0x6711476f207A86b6cf6673dC30EA89E7e7bE4567;
        address flipEngineAddress = 0xC26947E3A0FdA0f304969C0C9D0e66Fa9286B45B;
        FlipEngine flipEngine = FlipEngine(flipEngineAddress);
        
        string memory firstImagePath = "src/1.txt";
        string memory firstImageContent = vm.readFile(firstImagePath);
        
        uint256 chunkSize = 1000;
        uint256 contentLength = bytes(firstImageContent).length;
        console.log("First image length:", contentLength);
        
        vm.startBroadcast(deployerPrivateKey);
        uint64 nonce = vm.getNonce(msg.sender);
        uint256 chunkIndex = 0;
        for(uint256 i = 0; i < contentLength; i += chunkSize) {
            uint256 end = i + chunkSize;
            if(end > contentLength) {
                end = contentLength;
            }
            string memory chunk = substring(firstImageContent, i, end);
            console.log("Adding first image chunk %d/%d", chunkIndex, contentLength);
            
            vm.setNonce(msg.sender, nonce);
            flipEngine.addFirstImageChunk(deployedAddress, 17, chunkIndex, chunk);
            nonce++;
            chunkIndex++;
            
            vm.sleep(2000);
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