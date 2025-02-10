// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Diamond {
    address public owner;  // 存储拥有者地址
    mapping(bytes4 => address) public selectors;  // 存储函数选择器与 Facet 地址的映射

    // 构造函数，初始化拥有者地址
    constructor(address _owner) {
        owner = _owner;
    }

    // 修改所有者地址
    function setOwner(address _newOwner) external {
        require(msg.sender == owner, "Only owner can change owner");
        owner = _newOwner;
    }

    // 代理调用功能（fallback）
    fallback() external payable {
        address facet = selectors[msg.sig];  // 根据选择器查找对应的 Facet 合约地址
        require(facet != address(0), "Function not found in any facet");
        (bool success, ) = facet.delegatecall(msg.data);  // 调用 Facet 合约的对应方法
        require(success, "Delegatecall failed");
    }

    // 接收 Ether
    receive() external payable {}
}