// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

//@developed by andrew mitchell (andrewmitchell.eth)
contract FlipEngine is AccessControl {
    // Updated mappings to include contract address
    mapping(address => mapping(uint256 => bool)) public isFlipped;
    mapping(address => mapping(uint256 => bool)) public isFlipEnabled;
    
    mapping(address => mapping(uint256 => mapping(uint256 => string))) public firstImageChunks;
    mapping(address => mapping(uint256 => uint256)) public firstImageChunkCount;
    
    mapping(address => mapping(uint256 => mapping(uint256 => string))) public secondImageChunks;
    mapping(address => mapping(uint256 => uint256)) public secondImageChunkCount;
    
    constructor() {
    }

    function setFlipEnabled(address contractAddress, uint256 tokenId, bool enabled) external onlyAdmin {
        isFlipEnabled[contractAddress][tokenId] = enabled;
    }

    function addFirstImageChunk(address contractAddress, uint256 tokenId, uint256 chunkIndex, string calldata chunk) external onlyAdmin {
        firstImageChunks[contractAddress][tokenId][chunkIndex] = chunk;
        if (chunkIndex >= firstImageChunkCount[contractAddress][tokenId]) {
            firstImageChunkCount[contractAddress][tokenId] = chunkIndex + 1;
        }
    }

    function addSecondImageChunk(address contractAddress, uint256 tokenId, uint256 chunkIndex, string calldata chunk) external onlyAdmin {
        secondImageChunks[contractAddress][tokenId][chunkIndex] = chunk;
        if (chunkIndex >= secondImageChunkCount[contractAddress][tokenId]) {
            secondImageChunkCount[contractAddress][tokenId] = chunkIndex + 1;
        }
    }

    function flip(address contractAddress, uint256 tokenId) external onlyAuthorized {
        require(isFlipEnabled[contractAddress][tokenId], "Flipping is not enabled for this token");
        isFlipped[contractAddress][tokenId] = !isFlipped[contractAddress][tokenId];
    }

    function getFirstImageChunks(address contractAddress, uint256 tokenId, uint256 startIndex, uint256 endIndex) 
        external 
        view 
        returns (string[] memory) 
    {
        require(endIndex >= startIndex, "Invalid range");
        require(endIndex < firstImageChunkCount[contractAddress][tokenId], "Index out of bounds");
        
        string[] memory chunks = new string[](endIndex - startIndex + 1);
        for (uint256 i = startIndex; i <= endIndex; i++) {
            chunks[i - startIndex] = firstImageChunks[contractAddress][tokenId][i];
        }
        return chunks;
    }
    
    function getSecondImageChunks(address contractAddress, uint256 tokenId, uint256 startIndex, uint256 endIndex) 
        external 
        view 
        returns (string[] memory) 
    {
        require(endIndex >= startIndex, "Invalid range");
        require(endIndex < secondImageChunkCount[contractAddress][tokenId], "Index out of bounds");
        
        string[] memory chunks = new string[](endIndex - startIndex + 1);
        for (uint256 i = startIndex; i <= endIndex; i++) {
            chunks[i - startIndex] = secondImageChunks[contractAddress][tokenId][i];
        }
        return chunks;
    }
    
    function getFlipState(address contractAddress, uint256 tokenId) external view returns (bool) {
        return isFlipped[contractAddress][tokenId];
    }
    
    function getFlipEnabled(address contractAddress, uint256 tokenId) external view returns (bool) {
        return isFlipEnabled[contractAddress][tokenId];
    }

    function deleteFirstImage(address contractAddress, uint256 tokenId) public onlyAuthorized {
        for(uint256 i = 0; i < firstImageChunkCount[contractAddress][tokenId]; i++) {
            delete firstImageChunks[contractAddress][tokenId][i];
        }
        firstImageChunkCount[contractAddress][tokenId] = 0;
    }

    function deleteSecondImage(address contractAddress, uint256 tokenId) public onlyAuthorized {
        for(uint256 i = 0; i < secondImageChunkCount[contractAddress][tokenId]; i++) {
            delete secondImageChunks[contractAddress][tokenId][i];
        }
        secondImageChunkCount[contractAddress][tokenId] = 0;
    }

    function getImage(address contractAddress, uint256 tokenId) public view returns (string memory) {
        if(isFlipped[contractAddress][tokenId]) {
            return _getSecondImage(contractAddress, tokenId);
        } else {
            return _getFirstImage(contractAddress, tokenId);
        }
    }

    function _getFirstImage(address contractAddress, uint256 tokenId) internal view returns (string memory) {
        bytes memory result;
        for(uint256 i = 0; i < firstImageChunkCount[contractAddress][tokenId]; i++) {
            result = abi.encodePacked(result, firstImageChunks[contractAddress][tokenId][i]);
        }
        return string(result);
    }

    function _getSecondImage(address contractAddress, uint256 tokenId) internal view returns (string memory) {
        bytes memory result;
        for(uint256 i = 0; i < secondImageChunkCount[contractAddress][tokenId]; i++) {
            result = abi.encodePacked(result, secondImageChunks[contractAddress][tokenId][i]);
        }
        return string(result);
    }

    function getFirstImage(address contractAddress, uint256 tokenId) public view returns (string memory) {
        return _getFirstImage(contractAddress, tokenId);
    }

    function getSecondImage(address contractAddress, uint256 tokenId) public view returns (string memory)  {
        return _getSecondImage(contractAddress, tokenId);
    }

     function withdrawAll() 
        public 
        onlyAuthorized 
        nonReentrant 
    {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        (bool success, ) = payable(msg.sender).call{value: balance}("");
        require(success, "Transfer failed");
    }
}