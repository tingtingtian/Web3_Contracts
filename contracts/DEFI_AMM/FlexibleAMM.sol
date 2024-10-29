// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title FlexibleAMM - An optimized AMM contract that supports multiple pricing models
contract FlexibleAMM is ReentrancyGuard {
    enum Model { ConstantProduct, ConstantSum, StableSwap }

    Model public currentModel;
    uint256 public fee; // Fee percentage (e.g. 1 = 1%)
    
    address public tokenA;
    address public tokenB;

    // Liquidity reserves
    uint256 private reserveA;
    uint256 private reserveB;

    event ModelSwitched(Model model);
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event TokensSwapped(address indexed user, uint256 amountIn, uint256 amountOut);

    // Constructor to set the initial tokens and fee
    constructor(address _tokenA, address _tokenB, uint256 _fee) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        fee = _fee;
        currentModel = Model.ConstantProduct; // Default model
    }

    // Function to add liquidity
    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        require(amountA > 0 && amountB > 0, "Invalid amounts");
        
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
        
        reserveA += amountA;
        reserveB += amountB;
        
        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    // Function to switch models
    function switchModel(Model _model) external {
        currentModel = _model;
        emit ModelSwitched(_model);
    }

    // Function to swap tokens based on the current model
    function swap(uint256 amountIn) external nonReentrant returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid amount");

        // Calculate the output amount based on the current model
        if (currentModel == Model.ConstantProduct) {
            amountOut = getAmountOutConstantProduct(amountIn, reserveA, reserveB);
        } else if (currentModel == Model.ConstantSum) {
            amountOut = getAmountOutConstantSum(amountIn, reserveA, reserveB);
        } else if (currentModel == Model.StableSwap) {
            amountOut = getAmountOutStableSwap(amountIn, reserveA, reserveB);
        } else {
            revert("Unsupported model");
        }

        require(amountOut > 0, "Invalid output amount");
        
        // Charge fee
        uint256 feeAmount = (amountOut * fee) / 100;
        amountOut -= feeAmount;

        // Transfer tokens
        IERC20(tokenB).transfer(msg.sender, amountOut);
        reserveA += amountIn;
        reserveB -= (amountOut + feeAmount);

        emit TokensSwapped(msg.sender, amountIn, amountOut);
    }

    // Function to get output amount using Constant Product Model
    function getAmountOutConstantProduct(uint256 amountIn, uint256 _reserveA, uint256 _reserveB) private pure returns (uint256) {
        require(amountIn > 0, "Amount in must be greater than 0");
        require(_reserveA > 0 && _reserveB > 0, "Reserves must be greater than 0");

        uint256 amountInWithFee = amountIn * 997; // Assuming a fee of 0.3%
        uint256 numerator = amountInWithFee * _reserveB;
        uint256 denominator = (_reserveA * 1000) + amountInWithFee; // Adjusting for fee
        return numerator / denominator;
    }

    // Function to get output amount using Constant Sum Model
    function getAmountOutConstantSum(uint256 amountIn, uint256 _reserveA, uint256 _reserveB) private pure returns (uint256) {
        require(amountIn > 0, "Amount in must be greater than 0");
        require(_reserveA > 0 && _reserveB > 0, "Reserves must be greater than 0");
        // In constant sum model, amount out is simply the amount in as both reserves increase
        return amountIn; 
    }

    // Function to get output amount using Stable Swap Model
    function getAmountOutStableSwap(uint256 amountIn, uint256 _reserveA, uint256 _reserveB) private pure  returns (uint256) {
        require(amountIn > 0, "Amount in must be greater than 0");
        require(_reserveA > 0 && _reserveB > 0, "Reserves must be greater than 0");

        // A simple approximation for StableSwap. In a real implementation,
        // you would use a more complex algorithm to ensure stable asset swapping.
        return (amountIn * _reserveB) / (_reserveA + amountIn);
    }

    // Function to update fee
    function setFee(uint256 _fee) external {
        require(_fee <= 100, "Fee cannot exceed 100%"); // Fee should not exceed 100%
        fee = _fee;
    }

    // Function to get the current reserves
    function getReserves() external view returns (uint256, uint256) {
        return (reserveA, reserveB);
    }
}