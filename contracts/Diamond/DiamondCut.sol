// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDiamondCut {
    function diamondCut(address facetAddress, bytes4 selector, bool add) external;
}

contract DiamondCut is IDiamondCut {
    address public diamond;

    constructor(address _diamond) {
        diamond = _diamond;
    }

    function diamondCut(address facetAddress, bytes4 selector, bool add) external override {
        require(msg.sender == diamond, "Only diamond contract can call this function");

        if (add) {
            // 添加功能，将选择器与功能合约地址关联
            (bool success, ) = facetAddress.call(abi.encodeWithSelector(selector));
            require(success, "Function call failed");
        } else {
            // 移除功能，将选择器与功能合约地址的关联删除
            (bool success, ) = facetAddress.call(abi.encodeWithSelector(selector));
            require(success, "Function call failed");
        }
    }
}