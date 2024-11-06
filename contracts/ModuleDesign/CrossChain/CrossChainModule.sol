// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./ICrossChainModule.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract CrossChainModule is AccessControl, ICrossChainModule,Initializable {
    bytes32 public constant CROSS_CHAIN_ROLE = keccak256("CROSS_CHAIN_ROLE");

    // constructor(address admin) {
    //     _grantRole(DEFAULT_ADMIN_ROLE, admin);
    //     _grantRole(CROSS_CHAIN_ROLE, admin);
    // }
    function initialize(address admin) external initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(CROSS_CHAIN_ROLE, admin);
    }

    function sendAsset(address to, uint256 amount) onlyRole(CROSS_CHAIN_ROLE)  external{

    }
    function receiveAsset(address from, uint256 amount) onlyRole(CROSS_CHAIN_ROLE) external{

    }
    
}