// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicContract {
    uint256 public value; // 注意：这里的存储位置与调用者合约要一致

    function setValue(uint256 _value) public {
        value = _value;
    }
    function getValue() public view returns(uint256){
        return value;
    }

    function add(uint256 a,uint256 b) public  pure  returns (uint256){
        uint256 s =33;
        uint256 l = s +a +b;
        return l;
    }
}