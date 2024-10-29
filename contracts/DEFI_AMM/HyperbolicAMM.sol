// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HyperbolicAMM {
    using SafeMath for uint256;

    // 代币 A 和代币 B 的 ERC20 接口
    IERC20 public tokenA;
    IERC20 public tokenB;

    // 储备量
    uint256 public reserveA;
    uint256 public reserveB;

    // 事件定义
    event LiquidityProvided(address indexed provider, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);
    event Swap(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // 提供流动性
    function provideLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        // 更新储备量
        reserveA = reserveA.add(amountA);
        reserveB = reserveB.add(amountB);

        // 转移代币
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        emit LiquidityProvided(msg.sender, amountA, amountB);
    }

    // 移除流动性
    function removeLiquidity() external {
        uint256 amountA = reserveA;
        uint256 amountB = reserveB;

        require(amountA > 0 && amountB > 0, "No liquidity provided");

        // 清空储备量
        reserveA = 0;
        reserveB = 0;

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

    // 计算输出金额（双曲线公式）
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        require(amountIn > 0 && reserveIn > 0 && reserveOut > 0, "Invalid reserves or input");
        
        // 使用双曲线公式计算输出金额
        uint256 k = reserveIn.mul(reserveOut); // k 是恒定的乘积
        uint256 newReserveIn = reserveIn.add(amountIn);
        uint256 newReserveOut = k.div(newReserveIn); // 新的输出储备量
        return reserveOut.sub(newReserveOut); // 计算输出金额
    }
}