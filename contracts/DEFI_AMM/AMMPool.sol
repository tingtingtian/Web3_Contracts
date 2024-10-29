// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract AMMPool is ERC20, ReentrancyGuard {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 private constant FEE_PERCENTAGE = 3; // 手续费为 0.3%

    // 构造函数设置代币合约地址，并初始化 LP Token
    constructor(IERC20 _tokenA, IERC20 _tokenB) ERC20("AMM LP Token", "AMM-LP") {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    // 添加流动性
    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant returns (uint256 liquidity) {
        require(amountA > 0 && amountB > 0, "Invalid liquidity amounts");

        // 若池中已有流动性，根据储备比例验证输入
        if (reserveA > 0 && reserveB > 0) {
            require(amountA * reserveB == amountB * reserveA, "Unbalanced liquidity amounts");
        }

        // 转移用户代币到池中
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // 计算应分配的 LP Token 数量
        if (totalSupply() == 0) {
            // 首次添加流动性，直接按照总输入分配
            liquidity = sqrt(amountA * amountB);
        } else {
            // 非首次，根据储备比例计算
            liquidity = min((amountA * totalSupply()) / reserveA, (amountB * totalSupply()) / reserveB);
        }

        require(liquidity > 0, "Insufficient liquidity minted");

        // 更新储备量
        reserveA += amountA;
        reserveB += amountB;

        // 铸造流动性代币并转给用户
        _mint(msg.sender, liquidity);
    }

    // 移除流动性
    function removeLiquidity(uint256 liquidity) external nonReentrant returns (uint256 amountA, uint256 amountB) {
        require(liquidity > 0, "Invalid liquidity amount");
        require(balanceOf(msg.sender) >= liquidity, "Insufficient LP tokens");

        // 计算退还的代币数量
        amountA = (liquidity * reserveA) / totalSupply();
        amountB = (liquidity * reserveB) / totalSupply();

        require(amountA > 0 && amountB > 0, "Insufficient liquidity withdrawn");

        // 销毁 LP Token
        _burn(msg.sender, liquidity);

        // 更新储备
        reserveA -= amountA;
        reserveB -= amountB;

        // 将代币转回给用户
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    // 代币 A 到代币 B 的交换
    function swapAtoB(uint256 amountAIn, uint256 minAmountBOut) external nonReentrant returns (uint256 amountBOut) {
        require(amountAIn > 0, "Invalid input amount");

        uint256 amountAInWithFee = (amountAIn * (1000 - FEE_PERCENTAGE)) / 1000;
        amountBOut = (amountAInWithFee * reserveB) / (reserveA + amountAInWithFee);

        require(amountBOut >= minAmountBOut, "Slippage protection");

        // 转入代币 A
        tokenA.transferFrom(msg.sender, address(this), amountAIn);

        // 更新储备
        reserveA += amountAIn;
        reserveB -= amountBOut;

        // 发送代币 B 给用户
        tokenB.transfer(msg.sender, amountBOut);
    }

    // 代币 B 到代币 A 的交换
    function swapBtoA(uint256 amountBIn, uint256 minAmountAOut) external nonReentrant returns (uint256 amountAOut) {
        require(amountBIn > 0, "Invalid input amount");

        uint256 amountBInWithFee = (amountBIn * (1000 - FEE_PERCENTAGE)) / 1000;
        amountAOut = (amountBInWithFee * reserveA) / (reserveB + amountBInWithFee);

        require(amountAOut >= minAmountAOut, "Slippage protection");

        // 转入代币 B
        tokenB.transferFrom(msg.sender, address(this), amountBIn);

        // 更新储备
        reserveB += amountBIn;
        reserveA -= amountAOut;

        // 发送代币 A 给用户
        tokenA.transfer(msg.sender, amountAOut);
    }

    // 获取储备量
    function getReserves() external view returns (uint256, uint256) {
        return (reserveA, reserveB);
    }

    // 辅助函数：平方根计算
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    // 辅助函数：计算最小值
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }
}