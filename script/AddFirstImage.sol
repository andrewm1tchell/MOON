// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract AddFirstImage is Script {
    function run() public {  // Add chunkIndex parameter
     //   function run(uint256 chunkIndex) public {  // Add chunkIndex parameter
     uint256 chunkIndex = 0;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
      //  address deployedAddress = 0x471712732542Ea2b3BB0a7da11B865E328d65E99;
      //  address flipEngineAddress = 0x3f902bbdeD1C66f3259695f85505273C11bC1146;

        address deployedAddress = 0x5D33bf955F46Cf194ae742d5A1A6f4ADC50f118e;
        address flipEngineAddress = 0x457b961794d9F1037C63c3dd09E588Cb93567FAa;
        FlipEngine flipEngine = FlipEngine(flipEngineAddress);
        
        string memory firstImagePath = "src/1.txt";
        string memory firstImageContent = vm.readFile(firstImagePath);
        
        uint256 chunkSize = 20000;
        uint256 contentLength = bytes(firstImageContent).length;
        
        require(chunkIndex * chunkSize < contentLength, "Chunk index out of bounds");
        
        uint256 start = chunkIndex * chunkSize;
        uint256 end = start + chunkSize;
        if(end > contentLength) {
            end = contentLength;
        }
        
        string memory chunk = substring(firstImageContent, start, end);
        console2.log("Processing chunk %d", chunkIndex);
        
        vm.startBroadcast(deployerPrivateKey);
        flipEngine.addFirstImageChunk(deployedAddress, 16, chunkIndex, chunk);
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