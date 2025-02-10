// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiamondProxy {
    address public diamond;

    constructor(address _diamond) {
        diamond = _diamond;
    }

    fallback() external payable {
        address impl = diamond;
        require(impl != address(0), "Diamond proxy: implementation address is not set");
        (bool success, ) = impl.delegatecall(msg.data);
        require(success, "Diamond proxy: delegatecall failed");
    }

    receive() external payable {}
}