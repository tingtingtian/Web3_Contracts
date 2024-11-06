// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet {
    address payable public owner;

    // 事件：用于记录资金接收和提取的细节
    event Received(address sender, uint256 amount);
    event FallbackCalled(address sender, uint256 amount, bytes data);
    event TransferSent(address to, uint256 amount);
    event SendSent(address to, uint256 amount, bool success);
    event CallSent(address to, uint256 amount, bool success);

    constructor(){
        owner = payable(msg.sender);
    }

    // 接收纯以太币时自动调用
    receive() external payable {
        emit Received(msg.sender, msg.value); // 记录事件
    }

    // 调用不存在的函数时或直接转账时调用
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data); // 记录事件
    }

    // 使用 transfer 提取以太币
    function withdrawWithTransfer(uint256 _amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance");
        
        // 使用 transfer 方法，失败时会自动 revert
        owner.transfer(_amount);
        emit TransferSent(owner, _amount);
    }

    // 使用 send 提取以太币
    function withdrawWithSend(uint256 _amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance");
        
        // 使用 send 方法，失败时不会自动 revert，因此需要检查成功与否
        bool success = owner.send(_amount);
        require(success, "Send failed");
        
        emit SendSent(owner, _amount, success);
    }

    // 使用 call 提取以太币
    function withdrawWithCall(uint256 _amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance");
        
        // 使用 call 方法，可以设置更高的 Gas 限制
        (bool success, ) = owner.call{value: _amount}("");
        require(success, "Call failed");

        emit CallSent(owner, _amount, success);
    }

    // 查询合约余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}