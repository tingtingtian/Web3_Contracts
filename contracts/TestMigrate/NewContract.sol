// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOldContract {
    function balances(address user) external view returns (uint256);
}

contract NewContract {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // 从旧合约迁移数据
    function migrateData(address oldContractAddress, address[] calldata users) external {
        require(msg.sender == owner, "Only owner can migrate data");
        IOldContract oldContract = IOldContract(oldContractAddress);

        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            uint256 oldBalance = oldContract.balances(user);
            balances[user] += oldBalance;
        }
    }

    // 存款
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // 提款
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // 查询余额
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}