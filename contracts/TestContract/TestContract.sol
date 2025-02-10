// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;


contract TestContract {

    uint256 private testi ;

    function testDynamicArray() public pure {

    }

    function memoryGasTest() public pure returns (uint256[] memory) {
        uint256[] memory arr;  // 分配一个动态数组，长度为5
         for (uint256 i = 0; i < 5; i++) {
                 arr[i] = i + 1; // 写入数组元素
            }
         return arr;
    }   

    function  setTesti(uint256 value) public {
        testi = value;
    }


}