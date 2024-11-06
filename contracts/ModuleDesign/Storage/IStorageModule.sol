// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStorageModule {
    function uploadFile(string memory fileHash) external;
    function getFile(string memory fileHash) external view returns (string memory);
}