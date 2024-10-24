// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiUserExample {
    address public owner;

    constructor() {
        owner = msg.sender;  // 部署合约的人作为合约的 owner
    }

    function withdraw() public view{
        require(msg.sender == owner, "Only owner can withdraw funds");
        // 执行提现逻辑
    }
}
