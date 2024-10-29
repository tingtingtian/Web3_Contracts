// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ActiveLiquidityAMM {
    using SafeMath for uint256;

    // 代币 A 和代币 B 的 ERC20 接口
    IERC20 public tokenA;
    IERC20 public tokenB;

    // 储备量
    uint256 public reserveA;
    uint256 public reserveB;

    // 流动性提供者的流动性份额
    struct Position {
        uint256 amountA;
        uint256 amountB;
        uint256 priceLower; // 价格下限
        uint256 priceUpper; // 价格上限
    }

    mapping(address => Position) public positions;

    // 事件定义
    event LiquidityProvided(address indexed provider, uint256 amountA, uint256 amountB, uint256 priceLower, uint256 priceUpper);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);
    event Swap(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // 提供流动性，设置价格范围
    function provideLiquidity(uint256 amountA, uint256 amountB, uint256 priceLower, uint256 priceUpper) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");
        require(priceLower < priceUpper, "Invalid price range");

        // 更新储备量
        reserveA = reserveA.add(amountA);
        reserveB = reserveB.add(amountB);

        // 转移代币
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // 保存流动性提供者的流动性信息
        positions[msg.sender] = Position({
            amountA: amountA,
            amountB: amountB,
            priceLower: priceLower,
            priceUpper: priceUpper
        });

        emit LiquidityProvided(msg.sender, amountA, amountB, priceLower, priceUpper);
    }

    // 移除流动性
    function removeLiquidity() external {
        Position memory position = positions[msg.sender];
        require(position.amountA > 0 && position.amountB > 0, "No liquidity provided");

        // 计算可提取的代币数量（假设在当前价格下完全可提取）
        uint256 amountA = position.amountA;
        uint256 amountB = position.amountB;

        // 更新储备量
        reserveA = reserveA.sub(amountA);
        reserveB = reserveB.sub(amountB);

        // 清除用户流动性信息
        delete positions[msg.sender];

        // 转移代币到用户
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    // 进行代币交换
    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        require(amountIn > 0, "Amount must be greater than 0");

        address tokenOut;
        uint256 reserveIn;
        uint256 reserveOut;

        // 确定输入和输出代币
        if (tokenIn == address(tokenA)) {
            tokenOut = address(tokenB);
            reserveIn = reserveA;
            reserveOut = reserveB;
        } else if (tokenIn == address(tokenB)) {
            tokenOut = address(tokenA);
            reserveIn = reserveB;
            reserveOut = reserveA;
        } else {
            revert("Invalid token address");
        }

        // 计算输出金额
        amountOut = getAmountOut(amountIn, reserveIn, reserveOut);

        // 更新储备量
        if (tokenIn == address(tokenA)) {
            reserveA = reserveA.add(amountIn);
            reserveB = reserveB.sub(amountOut);
        } else {
            reserveB = reserveB.add(amountIn);
            reserveA = reserveA.sub(amountOut);
        }

        // 转移代币
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
    }

    // 计算输出金额
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        // 恒定乘积公式
        require(amountIn > 0 && reserveIn > 0 && reserveOut > 0, "Invalid reserves or input");
        uint256 amountInWithFee = amountIn.mul(997); // 0.3%手续费
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
        return numerator / denominator;
    }
}