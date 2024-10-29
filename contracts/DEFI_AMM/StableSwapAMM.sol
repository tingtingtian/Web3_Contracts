// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StableSwapAMM {
    // 两种代币的接口
    IERC20 public tokenA;
    IERC20 public tokenB;

    // 代币储备
    uint256 public reserveA;
    uint256 public reserveB;

    // 放大系数 A，用于控制稳定性
    uint256 public amplificationFactor;

    // 事件记录
    event Swap(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);
    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed user, uint256 amountA, uint256 amountB);

    // 初始化合约，设置代币和放大系数
    constructor(address _tokenA, address _tokenB, uint256 _initialReserveA, uint256 _initialReserveB, uint256 _amplificationFactor) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        reserveA = _initialReserveA;
        reserveB = _initialReserveB;
        amplificationFactor = _amplificationFactor;
    }

    // 添加流动性到池
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");

        // 将用户的代币转入合约
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // 更新储备量
        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    // 从池中移除流动性
    function removeLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA <= reserveA && amountB <= reserveB, "Insufficient reserves");

        // 从合约转出代币给用户
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        // 更新储备量
        reserveA -= amountA;
        reserveB -= amountB;

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    // 交换代币
    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        require(amountIn > 0, "Amount must be greater than 0");

        address tokenOut;
        if (tokenIn == address(tokenA)) {
            tokenOut = address(tokenB);
            amountOut = getAmountOut(amountIn, reserveA, reserveB);
            require(amountOut <= reserveB, "Insufficient reserveB");

            reserveA += amountIn;
            reserveB -= amountOut;
        } else if (tokenIn == address(tokenB)) {
            tokenOut = address(tokenA);
            amountOut = getAmountOut(amountIn, reserveB, reserveA);
            require(amountOut <= reserveA, "Insufficient reserveA");

            reserveB += amountIn;
            reserveA -= amountOut;
        } else {
            revert("Invalid token address");
        }

        // 转账代币
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenOut).transfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
    }

    // 计算输出数量，使用 StableSwap 公式
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256) {
        // 调整放大系数以减少滑点
        uint256 adjustedReserveIn = reserveIn * amplificationFactor;
        uint256 adjustedReserveOut = reserveOut * amplificationFactor;

        // 使用恒定和公式计算输出数量
        uint256 newReserveIn = adjustedReserveIn + amountIn;
        uint256 numerator = newReserveIn * adjustedReserveOut;
        uint256 denominator = adjustedReserveIn + adjustedReserveOut;

        uint256 amountOut = (numerator / denominator) - reserveOut;

        return amountOut;
    }
}