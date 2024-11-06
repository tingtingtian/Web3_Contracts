// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWalletModule {
    function getBalance() external view returns (uint256);
}