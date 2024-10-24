// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract HelloWorld {

  //3427 gas 
  string public messaege="Hello World";

  /**
  *视图函数,直接读取状态变量
  */
  //3457 gas
  function fn1() public view returns (string memory){
    return messaege;
  }

  /**
  *纯函数，从内存中直接返回
  */
  //785 gas 
  function fn2() public pure returns (string memory){
     return "Hello World!";
  }

   // 842 gas
  function fn3() public pure returns(string memory){
      return fn2(); // 使用方法；函数调用函数，没有this。直接调用
  }

}
