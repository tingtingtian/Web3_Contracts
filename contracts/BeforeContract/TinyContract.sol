// SPDX-License-Identifier: MIT


pragma solidity >=0.6.12 <0.9.0;  //跨版本调用
// pragma solidity 0.8.17; //指定版本
// pragma solidity >= 0.8.17 < 0.9.0; //等价于^0.8.17
// pragma solidity  ^0.8.17; //小版本兼容，大版本不兼容，相当于 pragma solidity >= 0.8.17 < 0.9.0;


/// @title  一个简单的数据存储演示
/// @author Anbang
/// @notice 您智能将此合约用于最基本的演示
/// @dev    提供了存储方法/获取方法
/// @custom:xx    自定义的描述/这个是实验的测试合约
contract  TinyStorage {

    //可以通过 address(this) 获取合约地址。
    //可以通过 this.fnName 获取 external 函数
    function contractAds() external view returns (address) {
        return address(this);
    }
  
    function testExternal() external view returns (address) {
        return this.contractAds();
    }
   
    address public owner1; //0x9ecEA68DE55F316B702f27eE389D10C2EE0dde84
    address public owner2; //0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 
    address public owner3;

    constructor(){
        owner1 = address(this); //合约地址
        owner2 = msg.sender; //合约创建者地址
    }

    //0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    //0x617F2E2fD72FD9D5503197092aC168c91465E7f2
    //谁调用, msg.sender就是谁的地址，合约调用者地址，切换账户，查看函数地址信息与调用账户地址一致
    function callerAddr() public  view  returns  (address) {
        return msg.sender;
    }


    // data
    uint256 storedData;

    /// @notice 储存 x
    /// @param _x: storedData 将要修改的值
    /// @dev   将数字存储在状态变量 storedData 中
    function set(uint256 _x) public{
        storedData = _x;
    }

    /// @notice 返回存储的值
    /// @return 储存值
    /// @dev   检索状态变量 storedData 的值
    function get() public view returns(uint256){
        return storedData;
    }


    /**
     * @notice 第二种写法
     * @param _x: XXXXX
     * @dev   XXXXX
     * @return XXXXX
     * @inheritdoc :
     */



}