// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Cat {
    uint256 public age;

    function eat() public returns (string memory) {
        age++;
        return "cat eat fish";
    }

    function sleep1() public pure returns (string memory) {
        return "sleep1";
    }
}

contract Dog {
    uint256 public age;

    function eat() public returns (string memory) {
        age += 2;
        return "dog miss you";
    }

    function sleep2() public pure returns (string memory) {
        return "sleep2";
    }
}

interface AnimalEat {
    function eat() external returns (string memory);
}

//库与合约类似，但它的目的是在一个指定的地址，且仅部署一次，然后通过 EVM 的特性来复用代码。
//一般适合工具类的使用
library Set {
    struct Data { mapping(uint => bool) flags; }
    function test() external pure  returns (uint256){
        return 666;
    }
}

contract Animal {
    function test(address _addr) external returns (string memory) {
        AnimalEat general = AnimalEat(_addr);
        return general.eat();
    }
    //返回接口I 的 bytes4 类型的接口 ID，接口 ID 参考： EIP-165 定义的， 接口 ID 被定义为 XOR （异或） 接口内所有的函数的函数选择器（除继承的函数。
    function interfaceId() external pure returns (bytes4) {
        return type(AnimalEat).interfaceId;
    }

    function testA() external  pure returns (uint256){
        return Set.test();
    }
}