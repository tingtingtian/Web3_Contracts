// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// public：可被任何人访问，自动生成 getter。
// private：仅当前合约可以访问，不能被继承。
// internal：当前合约及其派生合约可以访问。
// external：仅可从外部调用，不能在内部直接调用。
abstract contract Parent{
    uint256 public a ;
    uint256 private b=10;
    function addOne() public {
        a++;
    }
    function addThree() public virtual ;//如果没有体，就需要在子合约中强制实现
    function addFour() public virtual { //如果有体，就不需要在子合约中强制实现
        a +=4;
    }
}

contract Child is Parent{
    function addTwo() public {
        a+=2;
    }
    function addThree() public  override {
        a +=3;
    }

}

// ERC20: Fungible Toker 可交换的，一摸一样的，可切分的
// ERC721: NFT - Non-Fungible Token
