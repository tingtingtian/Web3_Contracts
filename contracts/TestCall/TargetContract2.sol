// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TargetContract {
    mapping(address => uint256) public balances;

    // Function to deposit ether into the contract and return a success flag
    function deposit(address _to, uint256 _amount) external payable returns (bool) {
        balances[_to] += _amount;
        return true; // Return true to indicate success
    }
}