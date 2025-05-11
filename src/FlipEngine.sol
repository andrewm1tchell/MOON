// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./AccessControl.sol";

//@developed by andrew mitchell (andrewmitchell.eth)
contract FlipEngine is AccessControl {
    mapping(uint256 => string) private _firstImageChunks;
    mapping(uint256 => string) private _secondImageChunks;
    uint256 private _firstImageChunkCount;
    uint256 private _secondImageChunkCount;
    bool private _flip = false;

    constructor() {
    }

    function addFirstImageChunk(uint256 chunkIndex, string memory chunkData) public onlyAuthorized {
        require(chunkIndex == _firstImageChunkCount, "Invalid chunk index");
        _firstImageChunks[chunkIndex] = chunkData;
        _firstImageChunkCount++;
    }

    function deleteFirstImage() public onlyAuthorized {
        for(uint256 i = 0; i < _firstImageChunkCount; i++) {
            delete _firstImageChunks[i];
        }
        _firstImageChunkCount = 0;
    }

    function addSecondImageChunk(uint256 chunkIndex, string memory chunkData) public onlyAuthorized {
        require(chunkIndex == _secondImageChunkCount, "Invalid chunk index");
        _secondImageChunks[chunkIndex] = chunkData;
        _secondImageChunkCount++;
    }

    function deleteSecondImage() public onlyAuthorized {
        for(uint256 i = 0; i < _secondImageChunkCount; i++) {
            delete _secondImageChunks[i];
        }
        _secondImageChunkCount = 0;
    }
    
    function flip() public onlyAuthorized {
        _flip = !_flip;
    }

    function isFlipped() public view returns(bool) {
        return _flip;
    }

    function getImage() public view returns (string memory) {
        if(_flip) {
            return _getSecondImage();
        } else {
            return _getFirstImage();
        }
    }

    function _getFirstImage() internal view returns (string memory) {
        bytes memory result;
        for(uint256 i = 0; i < _firstImageChunkCount; i++) {
            result = abi.encodePacked(result, _firstImageChunks[i]);
        }
        return string(result);
    }

    function _getSecondImage() internal view returns (string memory) {
        bytes memory result;
        for(uint256 i = 0; i < _secondImageChunkCount; i++) {
            result = abi.encodePacked(result, _secondImageChunks[i]);
        }
        return string(result);
    }

    function getFirstImage() public view returns (string memory) {
        return _getFirstImage();
    }

    function getSecondImage() public view returns (string memory)  {
        return _getSecondImage();
    }

    function withdrawAll() public onlyAuthorized {
        require(payable(msg.sender).send(address(this).balance));
    }
}