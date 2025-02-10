// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./EnhancedUserManagement.sol";

// 信用评分合约，集成外部数据源（如 Chainlink 预言机）以计算用户信用评分
contract EnhancedCreditScore is Ownable {
    // Chainlink 预言机接口实例
    AggregatorV3Interface internal priceFeed;
    // 用户管理合约地址
    address public userManagementContract;

    // 构造函数，初始化价格数据源和用户管理合约
    constructor(address _priceFeed, address _userManagementContract,address initialOwner) Ownable(initialOwner) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        userManagementContract = _userManagementContract;
    }

    // 获取最新的外部数据（例如价格信息）
    function getLatestData() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    // 计算用户的信用评分
    function calculateCreditScore(address userAddress) external view returns (uint256) {
        EnhancedUserManagement userManagement = EnhancedUserManagement(userManagementContract);
        require(userManagement.isUserRegistered(userAddress), "User not registered");

        // 获取外部数据，并根据基础评分进行调整
        int256 externalData = getLatestData();
        uint256 baseScore = 600; // 基本评分示例

        // 如果外部数据为负数，避免负数转换为 uint256 后的异常情况
        uint256 calculatedScore = baseScore + (externalData > 0 ? uint256(externalData) / 100 : 0);

        // 返回计算后的信用评分
        return calculatedScore;
    }
}
