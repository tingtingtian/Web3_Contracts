// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 逻辑合约0x7C4e30a43ecC4d3231b5B07ed082329020D141F3
contract LogicV1 {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}

// 新逻辑合约
contract LogicV2 {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value + 1; // 修改逻辑
    }
}

// 代理合约
contract Proxy {
    address public currentLogic;
    address payable internal  owner;

    // 事件用于日志记录
    event LogicUpdated(address newLogic);

    constructor(address _logic) {
        currentLogic = _logic;
        owner = payable (msg.sender);

    }

    // 使用 fallback 函数转发调用
    fallback() external payable {
        (bool success, ) = currentLogic.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    // 使用 receive 函数接收以太币
    receive() external payable {
        // 这里可以添加逻辑，处理接收到的以太币
        owner.transfer(address(this).balance);
    }

    // 使用 CREATE2 部署新逻辑合约
    function upgradeLogic(bytes32 salt) external {
        // 使用 CREATE2 部署新的逻辑合约
        LogicV2 newLogic = new LogicV2{ salt: salt }();
        currentLogic = address(newLogic); // 更新逻辑合约地址
        emit LogicUpdated(address(newLogic));
    }

    // 获取当前逻辑合约地址
    function getCurrentLogic() external view returns (address) {
        return currentLogic;
    }
}