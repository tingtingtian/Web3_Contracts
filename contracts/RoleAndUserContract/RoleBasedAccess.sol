// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleBasedAccess {
    address public owner;
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isUser;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Not an admin");
        _;
    }

    modifier onlyUser() {
        require(isUser[msg.sender], "Not a user");
        _;
    }

    function addAdmin(address admin) public onlyOwner {
        isAdmin[admin] = true;
    }

    function removeAdmin(address admin) public onlyOwner {
        isAdmin[admin] = false;
    }

    function addUser(address user) public onlyAdmin {
        isUser[user] = true;
    }

    function removeUser(address user) public onlyAdmin {
        isUser[user] = false;
    }
}

