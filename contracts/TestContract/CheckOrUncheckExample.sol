// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract C {
    function f(uint a, uint b) pure public returns (uint) {
        // 减法溢出会返回“截断”的结果
        unchecked { return a - b; } //返回较大的一个数115792089237316195423570985008687907853269984665640564039457584007913129639935
    }
    function g(uint a, uint b) pure public returns (uint) {
        // 在下溢时将回滚。
        return a - b;   //溢出时revert报错
    }
}