// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; // 引入 ReentrancyGuard 防止重入攻击
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleAMM is ReentrancyGuard {
    IERC20 public tokenA;  // 代币 A
    IERC20 public tokenB;  // 代币 B
    uint256 public reserveA;  // 合约中的代币 A 储备
    uint256 public reserveB;  // 合约中的代币 B 储备

    constructor(IERC20 _tokenA, IERC20 _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    // 添加流动性函数
    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA > 0 && amountB > 0, "Invalid amounts"); // 检查输入金额

        // 转移代币至合约
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // 更新储备
        reserveA += amountA;
        reserveB += amountB;
    }

    // 移除流动性函数
    function removeLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA <= reserveA && amountB <= reserveB, "Insufficient liquidity");

        // 更新储备：Checks-Effects-Interactions 模式，先更新状态
        reserveA -= amountA;
        reserveB -= amountB;

        // 归还代币
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    // 交换代币 A 到代币 B
    function swapAtoB(uint256 amountAIn) external nonReentrant returns (uint256 amountBOut) {
        require(amountAIn > 0, "Amount must be greater than zero");
        require(reserveA > 0 && reserveB > 0, "Insufficient reserves");

        // 计算兑换比例: 使用固定乘积公式 x * y = k
        uint256 amountAWithFee = (amountAIn * 997) / 1000; // 0.3% 手续费
        amountBOut = (amountAWithFee * reserveB) / (reserveA + amountAWithFee);

        require(amountBOut > 0, "Insufficient output amount");

        // 更新储备
        reserveA += amountAIn;
        reserveB -= amountBOut;

        // 代币交换：Checks-Effects-Interactions 模式，先更新储备再交互
        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);
    }

    // 交换代币 B 到代币 A
    function swapBtoA(uint256 amountBIn) external nonReentrant returns (uint256 amountAOut) {
        require(amountBIn > 0, "Amount must be greater than zero");
        require(reserveA > 0 && reserveB > 0, "Insufficient reserves");

        // 计算兑换比例: 使用固定乘积公式 x * y = k
        uint256 amountBWithFee = (amountBIn * 997) / 1000; // 0.3% 手续费
        amountAOut = (amountBWithFee * reserveA) / (reserveB + amountBWithFee);

        require(amountAOut > 0, "Insufficient output amount");

        // 更新储备
        reserveB += amountBIn;
        reserveA -= amountAOut;

        // 代币交换：Checks-Effects-Interactions 模式，先更新储备再交互
        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);
    }

    // 获取储备信息（只读函数）
    function getReserves() external view returns (uint256, uint256) {
        return (reserveA, reserveB);
    }
}