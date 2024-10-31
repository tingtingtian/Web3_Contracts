// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 定义接口
interface ICalculator {
    // 定义两个函数：add 和 subtract，返回结果为 uint
    function add(uint256 a, uint256 b) external pure returns (uint256);
    function subtract(uint256 a, uint256 b) external pure returns (uint256);
}