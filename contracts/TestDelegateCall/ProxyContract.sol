// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProxyContract {
    uint256 public value;         // 与逻辑合约存储位置相同
    address public logicContract; // 逻辑合约的地址

    constructor(address _logicContract) {
        logicContract = _logicContract;
    }

    event Response(bool success, bytes data);

    function setValueThroughDelegateCall(uint256 _value) public {
        (bool success, bytes memory data) = logicContract.delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        require(success, "Delegatecall failed");
        emit Response(success, data);
    }
}