// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 引入 OpenZeppelin 库的接口来定义 ERC20 代币标准
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ConstantSumAMM {
    // 代币 A 和 代币 B 的储备池
    IERC20 public tokenA;
    IERC20 public tokenB;

    // 初始化池中的代币储备数量
    uint256 public reserveA;
    uint256 public reserveB;

    // 事件：记录交易信息
    event Swap(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);
    event LiquidityAdded(address indexed user, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed user, uint256 amountA, uint256 amountB);

    // 构造函数：初始化 AMM 池，并指定交易的代币类型
    constructor(address _tokenA, address _tokenB, uint256 _initialReserveA, uint256 _initialReserveB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        reserveA = _initialReserveA;
        reserveB = _initialReserveB;
    }

    // 添加流动性到池中
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amount must be greater than 0");

        // 将用户代币转入合约
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // 更新储备
        reserveA += amountA;
        reserveB += amountB;

        // 触发流动性添加事件
        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    // 从池中移除流动性
    function removeLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA <= reserveA && amountB <= reserveB, "Insufficient reserves");

        // 将代币从合约转回给用户
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        // 更新储备
        reserveA -= amountA;
        reserveB -= amountB;

        // 触发流动性移除事件
        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    // 实现代币交换：用户可以使用代币 A 或 B 交换另一种代币
    function swap(address tokenIn, uint256 amountIn) external {
        require(amountIn > 0, "Amount must be greater than 0");

        address tokenOut;
        uint256 amountOut;

        // 如果输入代币为 tokenA，输出代币为 tokenB
        if (tokenIn == address(tokenA)) {
            tokenOut = address(tokenB);

            // 确定输出量：amountOut 等于输入量
            amountOut = amountIn;

            // 确保池中有足够的 B 代币供用户兑换
            require(amountOut <= reserveB, "Insufficient reserve B");

            // 更新储备
            reserveA += amountIn;
            reserveB -= amountOut;
        }
        // 如果输入代币为 tokenB，输出代币为 tokenA
        else if (tokenIn == address(tokenB)) {
            tokenOut = address(tokenA);

            // 确定输出量
            amountOut = amountIn;

            // 确保池中有足够的 A 代币供用户兑换
            require(amountOut <= reserveA, "Insufficient reserve A");

            // 更新储备
            reserveB += amountIn;
            reserveA -= amountOut;
        } else {
            revert("Invalid tokenIn address");
        }

        // 执行代币转账，将 tokenIn 转入合约
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        
        // 执行代币转账，将 tokenOut 转给用户
        IERC20(tokenOut).transfer(msg.sender, amountOut);

        // 触发交换事件
        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
    }

    // 获取池中代币的当前总和，检查是否接近初始总和
    function getCurrentSum() external view returns (uint256) {
        return reserveA + reserveB;
    }
}