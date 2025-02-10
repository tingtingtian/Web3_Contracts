// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// 用户管理合约，支持用户注册和数据隐私
contract EnhancedUserManagement is Ownable, ReentrancyGuard {
    // 定义用户结构体，包含注册状态、同意状态、信用评分、zk证明和加密数据
    struct User {
        bool isRegistered; // 用户是否已注册
        bool hasConsented; // 用户是否同意数据处理
        uint256 creditScore; // 用户的信用评分
        bytes32 zkProof; // 零知识证明，用于验证用户数据的真实性
        string encryptedData; // 加密的用户数据（如个人信息）
    }

    // 使用映射将用户地址与用户结构体关联
    mapping(address => User) public users;

    // 事件：用户注册成功时触发
    event UserRegistered(address indexed user);
    // 事件：用户同意状态更新时触发
    event UserConsentUpdated(address indexed user, bool consent);
    // 事件：用户数据更新时触发
    event UserDataUpdated(address indexed user, string newData);

    // 构造函数，不再需要传递 `initialOwner`
    constructor(address initialOwner) Ownable(initialOwner) {
         // custom initialization if needed
    }

    // 注册用户函数，包含零知识证明和加密数据
    function registerUser(bytes32 zkProof, string memory encryptedData) external nonReentrant {
        require(!users[msg.sender].isRegistered, "User already registered");
        // 初始化用户信息
        users[msg.sender] = User(true, false, 0, zkProof, encryptedData);
        emit UserRegistered(msg.sender);
    }

    // 校验用户是否注册的函数
    function isUserRegistered(address userAddress) external view returns (bool) {
        return users[userAddress].isRegistered;
    }

    // 更新用户同意状态函数
    function updateConsent(bool consent) external nonReentrant {
        require(users[msg.sender].isRegistered, "User not registered");
        users[msg.sender].hasConsented = consent;
        emit UserConsentUpdated(msg.sender, consent);
    }

    // 更新用户加密数据函数
    function updateUserEncryptedData(string memory newData) external nonReentrant {
        require(users[msg.sender].isRegistered, "User not registered");
        users[msg.sender].encryptedData = newData;
        emit UserDataUpdated(msg.sender, newData);
    }
}