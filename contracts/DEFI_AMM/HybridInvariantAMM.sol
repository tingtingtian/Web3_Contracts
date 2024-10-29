// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HybridInvariantAMM {
    using SafeMath for uint256;

    // 代币 A 和代币 B 的 ERC20 接口
    IERC20 public tokenA;
    IERC20 public tokenB;

    // 储备量
    uint256 public reserveA;
    uint256 public reserveB;

    // 放大系数和手续费
    uint256 public amplificationFactor; // 用于控制流动性池的灵活性
    uint256 public fee; // 手续费，以基点为单位，例如 30 = 0.3%

    // 流动性提供者的流动性份额
    mapping(address => uint256) public liquidityProviders;
    uint256 public totalLiquidity; // 总流动性

    // 事件定义
    event Swap(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut, uint256 fee);
    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB, uint256 liquidityMinted);
    event LiquidityRemoved(address indexed user, uint256 amountA, uint256 amountB, uint256 liquidityBurned);

    constructor(
        address _tokenA, 
        address _tokenB, 
        uint256 _initialReserveA, 
        uint256 _initialReserveB, 
        uint256 _amplificationFactor, 
        uint256 _fee
    ) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        reserveA = _initialReserveA;
        reserveB = _initialReserveB;
        amplificationFactor = _amplificationFactor;
        fee = _fee;
    }

    // 添加流动性
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        // 流动性份额计算
        uint256 liquidityMinted = amountA.add(amountB);
        liquidityProviders[msg.sender] = liquidityProviders[msg.sender].add(liquidityMinted);
        totalLiquidity = totalLiquidity.add(liquidityMinted);

        // 进行代币转移
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // 更新储备量
        reserveA = reserveA.add(amountA);
        reserveB = reserveB.add(amountB);

        emit LiquidityAdded(msg.sender, amountA, amountB, liquidityMinted);
    }

    // 移除流动性
    function removeLiquidity(uint256 liquidity) external {
        require(liquidity > 0, "Liquidity must be greater than 0");
        require(liquidityProviders[msg.sender] >= liquidity, "Insufficient liquidity");

        // 计算用户可取出的代币数量
        uint256 amountA = liquidity.mul(reserveA).div(totalLiquidity);
        uint256 amountB = liquidity.mul(reserveB).div(totalLiquidity);

        liquidityProviders[msg.sender] = liquidityProviders[msg.sender].sub(liquidity);
        totalLiquidity = totalLiquidity.sub(liquidity);

        // 更新储备量
        reserveA = reserveA.sub(amountA);
        reserveB = reserveB.sub(amountB);

        // 转移代币到用户
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidity);
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

        // 计算手续费并从输出金额中扣除
        uint256 feeAmount = amountOut.mul(fee).div(10000);
        amountOut = amountOut.sub(feeAmount);

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

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut, feeAmount);
    }

    // 计算输出金额，结合弹性公式
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256) {
        // 应用弹性公式
        uint256 adjustedReserveIn = reserveIn.mul(amplificationFactor);
        uint256 adjustedReserveOut = reserveOut.mul(amplificationFactor);

        // 计算新的储备量
        uint256 newReserveIn = adjustedReserveIn.add(amountIn);
        uint256 numerator = newReserveIn.mul(adjustedReserveOut);
        uint256 denominator = adjustedReserveIn.add(adjustedReserveOut);

        // 计算输出金额
        uint256 amountOut = (numerator / denominator).sub(reserveOut);
        return amountOut;
    }

    // 更新放大系数和手续费
    function updateParameters(uint256 newAmplificationFactor, uint256 newFee) external {
        require(msg.sender == address(this), "Only governance can update"); // 仅治理可更新参数
        amplificationFactor = newAmplificationFactor;
        fee = newFee;
    }
}