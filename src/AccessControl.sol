// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract AccessControl {
    address private _admin;
    mapping(address => bool) private _accessList;

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Not admin");
        _;
    }

    modifier onlyAuthorized() {
        require(msg.sender == _admin || _accessList[msg.sender], "Not authorized");
        _;
    }

    constructor() {
        _admin = msg.sender;
    }

    function grantAccess(address addr) public onlyAdmin {
        _accessList[addr] = true;
    }

    function revokeAccess(address addr) public onlyAdmin {
        _accessList[addr] = false;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _admin;
    }

    function hasAccess(address account) public view returns (bool) {
        return _accessList[account];
    }

}