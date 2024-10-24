// SPDX-License-Identifier: MIT
// MyNewContract.sol
pragma solidity ^0.8.0;

// 引入 RoleBasedAccess 合约
import "./RoleBasedAccess.sol";

contract MyNewContract is RoleBasedAccess {
    string public contractData;

    // 只有管理员才能调用的函数
    function setContractData(string memory newData) public onlyAdmin {
        contractData = newData;
    }

    // 只有所有者才能调用的函数
    function emergencyWithdraw() public onlyOwner {
        // 紧急情况下提取资金
        payable(owner).transfer(address(this).balance);
    }

    // 任意用户都可以调用的函数
    function viewData() public view returns (string memory) {
        return contractData;
    }
}
