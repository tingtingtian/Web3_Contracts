// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Oracles/IOracleModule.sol";
import "./CrossChain/ICrossChainModule.sol";
import "./Storage/IStorageModule.sol";
import "./Wallet/IWalletModule.sol";

contract MySmartContract is AccessControl {

    address public oracleProxy;
    address public crossChainProxy;
    address public storageProxy;
    address public walletProxy;

    constructor(address _oracleProxy, address _crossChainProxy, address _storageProxy, address _walletProxy) {
        oracleProxy = _oracleProxy;
        crossChainProxy = _crossChainProxy;
        storageProxy = _storageProxy;
        walletProxy = _walletProxy;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    
    function getOracleWeatherData() external view returns (string memory) {
        return IOracleModule(oracleProxy).getWeatherData();
    }

    // CrossChain and Storage module interactions can be implemented similarly
    function sendCrossChainData(address to, uint256 amount) external {
        ICrossChainModule(crossChainProxy).sendAsset(to, amount);
    }

    function getStorageData(string memory fileHash) external  {
        IStorageModule(storageProxy).uploadFile(fileHash);
    }

    function getWalletBalance() external view returns (uint256) {
        return IWalletModule(walletProxy).getBalance();
    }
}