// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICrossChainModule {
    function sendAsset(address to, uint256 amount) external;
    function receiveAsset(address from, uint256 amount) external;
}