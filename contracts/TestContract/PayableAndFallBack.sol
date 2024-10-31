// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
*payable用法
    标记函数，用于标记转账和接受eth. function deposit1() external payable {}
    标记地址，用于标记地址转账和接收eth  payable(msg.sender).transfer(address(this).balance);
*
*回退函数在两种情况被调用：
    向合约转账；
    如果使用 call 转账，会执行 fallback。
    如果使用合约内已有的 deposit 转账，不会执行 fallback
    
    执行合约不存在的方法:
    就会执行 fallback 函数。（执行合约不存在的方法时执行）
*
*/
contract Payable {
    // payable 标记函数 可以用于转账
    //function deposit1() external payable {}

    //设置以太数量，点击此方法会报错、不允许转账，没有被标记
    //function deposit2() external {}

    // payable 标记地址 把当前的合约地址的所有以太转给当前调用合约的账户
    // function withdraw() external {
    //     payable(msg.sender).transfer(address(this).balance);
    // }

    // 通过 balance 属性，来查看余额。 查看当前合约地址的以太数量
    // function getBalance() external view returns (uint256) {
    //     return address(this).balance;
    // }

    event Log(string funName, address from, uint256 value, bytes data);

    function deposit() external payable {}

    // 通过 balance 属性，来查看余额。
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    //可以在callData直接调用payable申明的函数并且不会报错
    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        // receive 被调用的时候不存在 msg.data，所以不使用这个，直接用空字符串
        emit Log("receive", msg.sender, msg.value, "");
    }
}