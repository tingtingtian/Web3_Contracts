// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Oracles/IOracleModule.sol";
import "./CrossChain/ICrossChainModule.sol";
import "./Storage/IStorageModule.sol";
import "./Wallet/IWalletModule.sol";

contract MySmartContract is AccessControl {

    address public oracleAddress;
    address public crossChainAddress;
    address public storageAddress;
    address public walletAddress;

    // bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    // bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
    // bytes32 public constant CROSSCHAIN_ROLE = keccak256("CROSSCHAIN_ROLE");
    // bytes32 public constant STORAGE_ROLE = keccak256("STORAGE_ROLE");

    // function updateOracleAddress(address newOracle) external onlyRole(ADMIN_ROLE) {
    //     oracleAddress = newOracle;
    // }


    // function updateCrossChainModule(address newCrossChain) external onlyRole(CROSSCHAIN_ROLE) {
    //     crossChainAddress = newCrossChain;
    // }

    // function updateStorageModule(address newStorage) external onlyRole(STORAGE_ROLE) {
    //     storageAddress = newStorage;
    // }

    // Example interaction with Oracle module
    // function getOracleWeatherData() external view onlyRole(ORACLE_ROLE) returns (string memory) {
    //     return IOracleModule(oracleAddress).getWeatherData();
    // }

    // // CrossChain and Storage module interactions can be implemented similarly
    // function sendCrossChainData(address to, uint256 amount) external  onlyRole(CROSSCHAIN_ROLE) {
    //     ICrossChainModule(crossChainAddress).sendAsset(to, amount);
    // }

    // function getStorageData(string memory fileHash) external  onlyRole(STORAGE_ROLE) {
    //     IStorageModule(storageAddress).uploadFile(fileHash);
    // }
    function getOracleWeatherData() external view returns (string memory) {
        return IOracleModule(oracleAddress).getWeatherData();
    }

    // CrossChain and Storage module interactions can be implemented similarly
    function sendCrossChainData(address to, uint256 amount) external {
        ICrossChainModule(crossChainAddress).sendAsset(to, amount);
    }

    function getStorageData(string memory fileHash) external  {
        IStorageModule(storageAddress).uploadFile(fileHash);
    }

    function getWalletBalance() external view returns (uint256) {
        return IWalletModule(walletAddress).getBalance();
    }
}