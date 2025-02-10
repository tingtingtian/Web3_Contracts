// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallerContract {
    event Response(bool success, bytes data);

    uint256 public result;

    function staticCallGetValue(address target) public {
        (bool success, bytes memory data) = target.staticcall(
            abi.encodeWithSignature("getValue()")
        );
        require(success, "Staticcall failed");

        result = abi.decode(data, (uint256));
        emit Response(success, abi.encode(result));
    }

    function getResult() public view returns (uint256) {
        return result;
    }
}