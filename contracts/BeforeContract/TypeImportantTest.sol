// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
**type(C).name:获得合约名

type(C).creationCode:获得包含创建合约字节码的内存字节数组。
它可以在内联汇编中构建自定义创建例程，
尤其是使用 create2 操作码。 不能在合约本身或派生的合约访问此属性。 因为会引起循环引用。

type(C).runtimeCode:获得合约的运行时字节码的内存字节数组。
这是通常由 C 的构造函数部署的代码。 
如果 C 有一个使用内联汇编的构造函数，那么可能与实际部署的字节码不同。 
还要注意库在部署时修改其运行时字节码以防范定期调用（guard against regular calls）。 
与 .creationCode 有相同的限制，不能在合约本身或派生的合约访问此属性。 因为会引起循环引用。
**/
contract Hello {
    string public message = "Hello World!";
}

contract Demo {
    function name() external pure returns (string memory) {
        return type(Hello).name;
    }

    function creationCode() external pure returns (bytes memory) {
        return type(Hello).creationCode;
    }
    function runtimeCode() external pure returns (bytes memory) {
        return type(Hello).runtimeCode;
    }
}
