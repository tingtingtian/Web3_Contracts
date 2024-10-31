// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICalculator.sol";  // 引入接口合约

// 实现接口的合约
contract Calculator is ICalculator {
    // 实现加法函数
    function add(uint256 a, uint256 b) external pure override returns (uint256) {
        return a + b;
    }

    // 实现减法函数
    function subtract(uint256 a, uint256 b) external pure override returns (uint256) {
        require(a >= b, "Result would be negative");
        return a - b;
    }
}