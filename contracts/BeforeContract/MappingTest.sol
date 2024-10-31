// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract MappingExample {
    mapping(address => uint) public balances;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}

contract MappingUser {
    uint256 public  tmp; 
    function f() public returns (uint) {
        MappingExample m = new MappingExample();
        m.update(100);
        tmp = m.balances(address(this));
        return m.balances(address(this));
    }
}