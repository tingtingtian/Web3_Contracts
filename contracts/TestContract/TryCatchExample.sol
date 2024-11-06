// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 声明一个自定义异常
error InsufficientBalance(uint256 requested, uint256 available);

contract SenderContract {
    // 定义发送以太币的函数，使用自定义异常
    function sendEther(address payable recipient, uint256 amount) public payable {
        if (amount > address(this).balance) {
            // 如果请求的金额超过合约余额，则抛出自定义异常
            revert InsufficientBalance({
                requested: amount,
                available: address(this).balance
            });
        }
        // 发送以太币
        recipient.transfer(amount);
    }
}

contract ReceiverContract {
    event Received(address sender, uint256 amount);

    // 接收以太币的回调函数
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}

contract TryCatchExample {
    event TransferFailed(string reason);

    SenderContract public senderContract;
    ReceiverContract public receiverContract;

    constructor() {
        // 部署新的 SenderContract 和 ReceiverContract 实例
        senderContract = new SenderContract();
        receiverContract = new ReceiverContract();
    }

    // 尝试调用 SenderContract 中的 sendEther 函数，并捕获异常
    function executeTransfer(uint256 amount) public payable {
        try senderContract.sendEther{value: msg.value}(payable(address(receiverContract)), amount) {
            // 如果成功执行则不做任何事情
        } catch Error(string memory reason) {
            // 捕获标准错误消息
            emit TransferFailed(reason);
        } catch (bytes memory /*lowLevelData*/) {
            // 捕获低级调用错误（比如发送失败）
            emit TransferFailed("Low-level error");
        }
    }

    // 查询 SenderContract 合约的余额
    function getSenderBalance() public view returns (uint256) {
        return address(senderContract).balance;
    }
}