// SPDX-License-Identifier: MIT
// AnotherContract.sol
pragma solidity ^0.8.0;
import "./RoleBasedAccess.sol";

contract AnotherContract is RoleBasedAccess {
    uint256 public value;

    function setValue(uint256 newValue) public onlyAdmin {
        value = newValue;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}

