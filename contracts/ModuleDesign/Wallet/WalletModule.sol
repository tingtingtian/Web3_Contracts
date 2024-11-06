// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IWalletModule.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract WalletModule is AccessControl,IWalletModule,Initializable{
    bytes32 public constant WALLET_ROLE = keccak256("WALLET_ROLE");

    // constructor(address admin) {
    //     _grantRole(DEFAULT_ADMIN_ROLE, admin);
    //     _grantRole(WALLET_ROLE, admin);
    // }
    function initialize(address admin) external initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(WALLET_ROLE, admin);
    }
    receive() external payable {}

    function withdraw(uint256 amount, address payable to) external onlyRole(WALLET_ROLE) {
        require(address(this).balance >= amount, "Insufficient balance");
        to.transfer(amount);
    }

    function getBalance()  onlyRole(WALLET_ROLE) external view override returns (uint256) {
        return address(this).balance;
    }
}