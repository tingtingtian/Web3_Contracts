// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IOracleModule.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract OracleModule is IOracleModule,AccessControl,Initializable {
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
    
    // constructor(address admin) {
    //     _grantRole(DEFAULT_ADMIN_ROLE, admin);
    //     _grantRole(ORACLE_ROLE, admin);
    // }
    function initialize(address admin) external initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(ORACLE_ROLE, admin);
    }
    function getLatestPrice() external view onlyRole(ORACLE_ROLE) returns (uint256){
        uint256 a= 20;
        return a;
    }
    function getWeatherData() external view  onlyRole(ORACLE_ROLE) returns (string memory){
        string memory str = "Hello, Solidity!";
        return str;
    }
}