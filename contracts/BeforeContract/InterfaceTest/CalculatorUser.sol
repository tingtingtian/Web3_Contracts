// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICalculator.sol";

contract CalculatorUser {
    // 使用接口声明变量
    ICalculator public calculator;

    // 在部署时指定具体的 Calculator 合约地址
    constructor(address _calculatorAddress) {
        calculator = ICalculator(_calculatorAddress);
    }

    // 使用接口的 add 函数
    function addNumbers(uint256 a, uint256 b) public view returns (uint256) {
        return calculator.add(a, b);
    }

    // 使用接口的 subtract 函数
    function subtractNumbers(uint256 a, uint256 b) public view returns (uint256) {
        return calculator.subtract(a, b);
    }
}