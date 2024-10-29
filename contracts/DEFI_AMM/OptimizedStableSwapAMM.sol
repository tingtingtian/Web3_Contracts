// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract OptimizedStableSwapAMM {
    using SafeMath for uint256;

    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 public amplificationFactor;
    uint256 public fee;  // Fee in basis points, e.g., 30 = 0.3%

    mapping(address => uint256) public liquidityProviders;
    uint256 public totalLiquidity;

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

    // 添加流动性并跟踪流动性提供者份额
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        uint256 liquidityMinted = amountA.add(amountB); // 简单的 LP 代币计算
        liquidityProviders[msg.sender] = liquidityProviders[msg.sender].add(liquidityMinted);
        totalLiquidity = totalLiquidity.add(liquidityMinted);

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        reserveA = reserveA.add(amountA);
        reserveB = reserveB.add(amountB);

        emit LiquidityAdded(msg.sender, amountA, amountB, liquidityMinted);
    }

    // 移除流动性并返回用户的代币份额
    function removeLiquidity(uint256 liquidity) external {
        require(liquidity > 0, "Liquidity must be greater than 0");
        require(liquidityProviders[msg.sender] >= liquidity, "Insufficient liquidity");

        uint256 amountA = liquidity.mul(reserveA).div(totalLiquidity);
        uint256 amountB = liquidity.mul(reserveB).div(totalLiquidity);

        liquidityProviders[msg.sender] = liquidityProviders[msg.sender].sub(liquidity);
        totalLiquidity = totalLiquidity.sub(liquidity);

        reserveA = reserveA.sub(amountA);
        reserveB = reserveB.sub(amountB);

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidity);
    }

    // 核心的 swap 函数，包含手续费和滑点保护
    function swap(address tokenIn, uint256 amountIn, uint256 maxSlippage) external returns (uint256 amountOut) {
        require(amountIn > 0, "Amount must be greater than 0");

        address tokenOut;
        uint256 reserveIn;
        uint256 reserveOut;
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

        amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        
        // 计算手续费
        uint256 feeAmount = amountOut.mul(fee).div(10000); // Basis points fee
        amountOut = amountOut.sub(feeAmount);

        // 确保滑点控制在用户预期内
        uint256 slippage = amountOut.mul(10000).div(amountIn);
        require(slippage >= maxSlippage, "Exceeded max slippage");

        // 更新储备量
        if (tokenIn == address(tokenA)) {
            reserveA = reserveA.add(amountIn);
            reserveB = reserveB.sub(amountOut);
        } else {
            reserveB = reserveB.add(amountIn);
            reserveA = reserveA.sub(amountOut);
        }

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut, feeAmount);
    }

    // 计算输出金额，考虑放大因子和恒定和公式
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256) {
        uint256 adjustedReserveIn = reserveIn.mul(amplificationFactor);
        uint256 adjustedReserveOut = reserveOut.mul(amplificationFactor);

        uint256 newReserveIn = adjustedReserveIn.add(amountIn);
        uint256 numerator = newReserveIn.mul(adjustedReserveOut);
        uint256 denominator = adjustedReserveIn.add(adjustedReserveOut);

        uint256 amountOut = (numerator / denominator).sub(reserveOut);
        return amountOut;
    }

    // 更新放大系数和手续费，加入治理功能
    function updateParameters(uint256 newAmplificationFactor, uint256 newFee) external {
        require(msg.sender == address(this), "Only governance can update"); // 简单治理示例
        amplificationFactor = newAmplificationFactor;
        fee = newFee;
    }
}