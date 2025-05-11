// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlipEngine} from "../src/FlipEngine.sol";

contract AddFirstImage is Script {
    function run() public {
        address deployedAddress = 0xb07Db852819E065f842c699772Be912314a1b742;
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        string memory firstImagePath = "src/1.txt";
        string memory firstImageContent = vm.readFile(firstImagePath);
        
        uint256 chunkSize = 1000;
        uint256 contentLength = bytes(firstImageContent).length;
        console.log("First image length:", contentLength);
        
        uint256 chunkIndex = 0;
        for(uint256 i = 0; i < contentLength; i += chunkSize) {
            uint256 end = i + chunkSize;
            if(end > contentLength) {
                end = contentLength;
            }
            string memory chunk = substring(firstImageContent, i, end);
            console.log("Adding first image chunk %d/%d", chunkIndex, contentLength);
            (bool success, ) = deployedAddress.call(
                abi.encodeWithSignature("addFirstImageChunk(uint256,string)", chunkIndex, chunk)
            );
            require(success, "Failed to add chunk");
            chunkIndex++;
        }
        
        vm.stopBroadcast();
    }
    
    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for(uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}