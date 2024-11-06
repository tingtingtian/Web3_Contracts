// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IStorageModule.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract StorageModule is AccessControl, IStorageModule ,Initializable{
    bytes32 public constant STORAGE_ROLE = keccak256("STORAGE_ROLE");

    // constructor(address admin) {
    //     _grantRole(DEFAULT_ADMIN_ROLE, admin);
    //     _grantRole(STORAGE_ROLE, admin);
    // }
    function initialize(address admin) external initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(STORAGE_ROLE, admin);
    }

    function uploadFile(string memory fileHash) onlyRole(STORAGE_ROLE) external{

    }
    function getFile(string memory fileHash) onlyRole(STORAGE_ROLE) external view returns (string memory){

    }
}