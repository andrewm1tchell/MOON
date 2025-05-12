// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@manifoldxyz/creator-core-solidity/contracts/core/IERC721CreatorCore.sol";
import "@manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";
import "@manifoldxyz/libraries-solidity/contracts/access/IAdminControl.sol";
import "@manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol";
import "@manifoldxyz/creator-core-solidity/contracts/extensions/CreatorExtension.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IManifoldERC721Edition.sol";
import "./Base64.sol";
import "./FlipEngine.sol";
import "./AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/*
 * ___                    _ _  _     _          _  _    ___ 
 *  |   /\ |\/| \    /|_||_|_)|_ \_// \| |  /\ |_)|_|\ |/|  
 * _|_ /--\|  |  \/\/ | ||_| \|_  | \_/|_| /--\| \|_| \| |  
*/

//@artist omentejovem (omentejovem.eth)
//@developer andrew mitchell (andrewmitchell.eth)
contract IAWYAExtension is AdminControl, CreatorExtension, ICreatorExtensionTokenURI, IManifoldERC721Edition, AccessControl {
    using Strings for uint256;
    using SafeMath for uint256;
    FlipEngine flipEngine;

    uint256 private _totalSupply = 0;
    uint256 private _maxSupply = 1;
    uint256 private _tokenId;
    address private _creator;
    string private _externalUrl = "https://www.omentejovem.com/";
    string private _description = "";
    string private _name = "";

    modifier onlyAuthorizedAndTokenOwner(uint256 tokenId) {
        require(
            isOwner() || 
            hasAccess(msg.sender) || 
            msg.sender == IERC721(_creator).ownerOf(tokenId), 
            "Not Authorized"
        );
        _;
    }

    constructor(address creator, string memory name, string memory description, address flipEngineAddr)
    {
        _name = name;
        _description = description;
        _creator = creator;
        flipEngine = FlipEngine(flipEngineAddr); 
        grantAccess(0xF1Da6E2d387e9DA611dAc8a7FC587Eaa4B010013);
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(AdminControl, CreatorExtension, IERC165) returns (bool) {
        return interfaceId == type(ICreatorExtensionTokenURI).interfaceId || interfaceId == type(IManifoldERC721Edition).interfaceId || interfaceId == type(AdminControl).interfaceId ||
               CreatorExtension.supportsInterface(interfaceId);
    }

    function totalSupply() external view returns(uint256) {
        return _totalSupply;
    }

    function maxSupply() external view returns(uint256) {
        return _maxSupply;
    }

    function mint(address recipient) external payable onlyAuthorized {
        require(_totalSupply < _maxSupply, "No more tokens left");

        IERC721CreatorCore(_creator).mintExtension(recipient);

        _totalSupply++;
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

    function setDescription(string memory des) public onlyAuthorized {
        _description = des;
    }

    function setName(string memory name) public onlyAuthorized {
        _name = name;
    }

    function setExternalUrl(string memory externalUrl) public onlyAuthorized {
        _externalUrl = externalUrl;
    }

    function setTokenId(uint256 tokenId) public onlyAuthorized {
        _tokenId = tokenId;
    }
    
    function tokenURI(address creator, uint256 tokenId) public view virtual override returns (string memory) {
        return formatTokenURI();
    }

    function setFlipEngine(address flipEngineAddr) public onlyAuthorized {
        flipEngine = FlipEngine(flipEngineAddr);
    }

    function flip() public onlyAuthorizedAndTokenOwner(_tokenId) {
        flipEngine.flip(_tokenId);
    }

    function isFlipped() public view returns(bool) {
        return flipEngine.getFlipState(_tokenId);
    }

    function formatTokenURI() public view returns (string memory) {
        string memory imageUri = flipEngine.getImage(_tokenId);
        string memory byteEncoded = Base64.encode(bytes(abi.encodePacked(
            '{"name": "', 
            _name, 
            '", "description": "', 
            _description, 
            '", "external_url": "', 
            _externalUrl, 
            '", "image": "',
             imageUri,
              '"}'
        )));
        return string(abi.encodePacked("data:application/json;base64,", byteEncoded));
    }

    function animToURI(string memory anim) public pure returns (string memory) {
        return string(abi.encodePacked("data:text/html;base64,", Base64.encode(bytes(anim))));
    }
}