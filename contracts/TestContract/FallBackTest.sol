// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StoneCat {
    uint256 public age = 0;
    event eventFallback(string);

    // 发送到这个合约的所有消息都会调用此函数（因为该合约没有其它函数）。
    // 向这个合约发送以太币会导致异常，因为 fallback 函数没有 `payable` 修饰符
    fallback() external {
        age++;
        emit eventFallback("fallbak");
    }
}

interface AnimalEat {
    function eat() external returns (string memory);
}

contract Animal {
    function test1(address _addr) external returns (string memory) {
        AnimalEat general = AnimalEat(_addr);
        return general.eat();
    }
    function test2(address _addr) external returns (bool success) {
        AnimalEat general = AnimalEat(_addr);
        (success,) = address(general).call(abi.encodeWithSignature("eat()"));
        require(success);
    }
}