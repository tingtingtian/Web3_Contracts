// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallerContract {
    event Response(bool success, bytes data);

    function callSetValue(address target, uint256 _value) public payable {
        (bool success, bytes memory data) = target.call{value: msg.value}(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        emit Response(success, data);
    }
}