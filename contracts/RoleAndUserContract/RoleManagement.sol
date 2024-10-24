// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 使用 OpenZeppelin 的 AccessControl 模块
import "@openzeppelin/contracts/access/AccessControl.sol";

contract RoleManagement is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    constructor() {
       // _setupRole(ADMIN_ROLE, msg.sender); // 部署者成为管理员
    }

    function addUser(address account) public {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        grantRole(USER_ROLE, account);
    }

    function restrictedFunction() public view {
        require(hasRole(USER_ROLE, msg.sender), "Caller is not a user");
        // 执行用户角色的逻辑
    }
}
