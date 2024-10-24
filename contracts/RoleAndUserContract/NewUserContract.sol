// SPDX-License-Identifier: MIT
// NewUserContract.sol
pragma solidity ^0.8.0;
import "./RoleBasedAccess.sol";

contract NewUserContract is RoleBasedAccess {
    function userFunction() public onlyUser {
        // 只有用户角色可以调用的函数
    }
}
