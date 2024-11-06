// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracleModule {
    function getLatestPrice() external view returns (uint256);
    function getWeatherData() external view returns (string memory);
}