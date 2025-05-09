// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./AccessControl.sol";

//@developed by andrew mitchell (andrewmitchell.eth)
contract FlipEngine is AccessControl{
    string private _firstImageDataUri;
    string private _secondImageDataUri;
    uint256 private _tokenId;
    bool private _flip = false;

    constructor() {
    }

    function addFirstImageChunk(string memory chunkData) public onlyAuthorized {
        _firstImageDataUri = string(abi.encodePacked(_firstImageDataUri, chunkData));
    }

    function deleteFirstImage() public onlyAuthorized {
        _firstImageDataUri = "";
    }

    function addSecondImageChunk(string memory chunkData) public onlyAuthorized {
        _secondImageDataUri = string(abi.encodePacked(_secondImageDataUri, chunkData));
    }

    function deleteSecondImage() public onlyAuthorized {
        _secondImageDataUri = "";
    }
    
    function flip() public onlyAuthorized {
        _flip = !_flip;
    }

    function getImage() public view returns (string memory) {
        if(_flip) {
           return _secondImageDataUri;
        } else {
           return _firstImageDataUri;
        }
    }

    function getFirstImage() public view returns (string memory) {
        return _firstImageDataUri;
    }

    function getSecondImage() public view returns (string memory)  {
        return _secondImageDataUri;
    }

    function withdrawAll() public onlyAuthorized {
        require(payable(msg.sender).send(address(this).balance));
    }
}