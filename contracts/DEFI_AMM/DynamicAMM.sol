// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DynamicAMM {
    using SafeMath for uint256;

    enum Model { ConstantProduct, ConstantSum, StableSwap }

    struct Pool {
        IERC20 tokenA;
        IERC20 tokenB;
        uint256 reserveA;
        uint256 reserveB;
        Model currentModel;
        uint256 fee; // 交易手续费
        uint256 totalSupply; // LP代币总供应量
    }

    mapping(address => Pool) public pools;

    event LiquidityProvided(address indexed provider, address indexed pool, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, address indexed pool, uint256 amountA, uint256 amountB);
    event Swap(address indexed user, address indexed pool, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);
    event ModelSwitched(address indexed pool, Model newModel);
    event FeeUpdated(address indexed pool, uint256 newFee);

    // 创建流动性池
    function createPool(address tokenA, address tokenB, uint256 fee) external {
        require(tokenA != tokenB, "Tokens must be different");
        require(fee <= 1000, "Fee must be less than or equal to 1000"); // 限制手续费最高为10%

        pools[msg.sender] = Pool({
            tokenA: IERC20(tokenA),
            tokenB: IERC20(tokenB),
            reserveA: 0,
            reserveB: 0,
            currentModel: Model.ConstantProduct, // 默认使用恒定乘积模型
            fee: fee,
            totalSupply: 0
        });
    }

    // 提供流动性
    function provideLiquidity(address poolAddress, uint256 amountA, uint256 amountB) external {
        Pool storage pool = pools[poolAddress];

        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        pool.reserveA = pool.reserveA.add(amountA);
        pool.reserveB = pool.reserveB.add(amountB);

        pool.tokenA.transferFrom(msg.sender, address(this), amountA);
        pool.tokenB.transferFrom(msg.sender, address(this), amountB);

        // 计算LP代币供应量
        if (pool.totalSupply == 0) {
            pool.totalSupply = amountA.add(amountB);
        } else {
            uint256 liquidity = min(amountA.mul(pool.totalSupply)/pool.reserveA, amountB.mul(pool.totalSupply)/pool.reserveB);
            pool.totalSupply = pool.totalSupply.add(liquidity);
        }

        emit LiquidityProvided(msg.sender, poolAddress, amountA, amountB);
    }
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    // 移除流动性
    function removeLiquidity(address poolAddress, uint256 lpAmount) external {
        Pool storage pool = pools[poolAddress];

        require(lpAmount > 0, "LP amount must be greater than 0");
        require(pool.totalSupply > 0, "No liquidity provided");

        uint256 amountA = lpAmount.mul(pool.reserveA) / pool.totalSupply;
        uint256 amountB = lpAmount.mul(pool.reserveB) / pool.totalSupply;

        pool.reserveA = pool.reserveA.sub(amountA);
        pool.reserveB = pool.reserveB.sub(amountB);
        pool.totalSupply = pool.totalSupply.sub(lpAmount);

        pool.tokenA.transfer(msg.sender, amountA);
        pool.tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, poolAddress, amountA, amountB);
    }

    // 代币交换
    function swap(address poolAddress, address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        Pool storage pool = pools[poolAddress];

        require(amountIn > 0, "Amount must be greater than 0");

        address tokenOut;
        uint256 reserveIn;
        uint256 reserveOut;

        if (tokenIn == address(pool.tokenA)) {
            tokenOut = address(pool.tokenB);
            reserveIn = pool.reserveA;
            reserveOut = pool.reserveB;
        } else if (tokenIn == address(pool.tokenB)) {
            tokenOut = address(pool.tokenA);
            reserveIn = pool.reserveB;
            reserveOut = pool.reserveA;
        } else {
            revert("Invalid token address");
        }

        // 根据当前模型计算输出金额
        amountOut = calculateAmountOut(amountIn, reserveIn, reserveOut, pool.currentModel, pool.fee);

        // 更新储备量
        if (tokenIn == address(pool.tokenA)) {
            pool.reserveA = reserveIn.add(amountIn);
            pool.reserveB = reserveOut.sub(amountOut);
        } else {
            pool.reserveB = reserveIn.add(amountIn);
            pool.reserveA = reserveOut.sub(amountOut);
        }

        // 转移代币
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);

        emit Swap(msg.sender, poolAddress, tokenIn, amountIn, tokenOut, amountOut);
    }

    // 计算输出金额
    function calculateAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut, Model model, uint256 fee) internal pure returns (uint256) {
        // 扣除手续费
        uint256 amountInWithFee = amountIn.mul(1000 - fee).div(1000);

        if (model == Model.ConstantProduct) {
            // 恒定乘积模型
            return (reserveOut.mul(amountInWithFee)).div(reserveIn.add(amountInWithFee));
        } else if (model == Model.ConstantSum) {
            // 恒定和模型
            return amountInWithFee; // 在恒定和模型中，输出等于输入
        } else if (model == Model.StableSwap) {
            // 稳定交换模型的简化实现
            return (amountInWithFee.mul(reserveOut)).div(reserveIn.add(amountInWithFee)); // 需要根据实际模型进行调整
        } else {
            revert("Invalid model");
        }
    }

    // 切换模型
    function switchModel(address poolAddress, Model newModel) external {
        Pool storage pool = pools[poolAddress];
        pool.currentModel = newModel;
        emit ModelSwitched(poolAddress, newModel);
    }

    // 更新手续费
    function updateFee(address poolAddress, uint256 newFee) external {
        require(newFee <= 1000, "Fee must be less than or equal to 1000"); // 限制手续费最高为10%
        Pool storage pool = pools[poolAddress];
        pool.fee = newFee;
        emit FeeUpdated(poolAddress, newFee);
    }
}