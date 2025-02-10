// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OldContract {
    mapping(address => uint256) public balances;

    // 存款函数
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // 查询余额
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}