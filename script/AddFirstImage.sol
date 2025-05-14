// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract AddFirstImage is Script {
    function run(uint256 chunkIndex) public {  // Add chunkIndex parameter
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        address deployedAddress = 0x7B8140763e5046e920fB752ee1A2FBfb45247675;
        address flipEngineAddress = 0x5fa41D52B044ebD0a9Eda3cdbB75eAE61C1dd345;
        FlipEngine flipEngine = FlipEngine(flipEngineAddress);
        
        string memory firstImagePath = "src/1.txt";
        string memory firstImageContent = vm.readFile(firstImagePath);
        
        uint256 chunkSize = 5000;
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
        flipEngine.addFirstImageChunk(deployedAddress, 18, chunkIndex, chunk);
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