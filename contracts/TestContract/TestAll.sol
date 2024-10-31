// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

//测试修改器不能重载
contract Purchase {
    address public seller;

    modifier onlySeller() { // 修改器
        require(
            msg.sender == seller //"只有卖家可以调用此函数。"
        );
        _;
    }

    // modifier onlySeller(address owner){
    //     require(
    //         msg.sender == owner //"只有卖家可以调用此函数。"
    //     );
    //     _;
    // }

    function abort() public view onlySeller { // 修改器使用
       
    }
}

//测试函数修改器的重写关键字
contract Base
{
    modifier foo() virtual {_;}
}
contract Inherited is Base
{
    modifier foo() override {_;}
}

//测试函数修改器的多重继承时的父类必须显示声明
contract Base1
{
    modifier foo() virtual {_;}
}

contract Base2
{
    modifier foo() virtual {_;}
}

contract Inherited1 is Base1, Base2
{
    modifier foo() override(Base1, Base2) {_;}
}

//测试事件的定义并且触发事件
event HighestBidIncreased(address bidder, uint amount); // 事件

contract SimpleAuction {
    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // 触发事件
    }
}

//测试错误的定义与使用
/// 转账资金不足。请求的 `requested`，
/// 但只有 `available` 可用。
error NotEnoughFunds(uint requested, uint available);
contract Token {
    mapping(address => uint) balances;
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        if (balance < amount)
            revert NotEnoughFunds(amount, balance);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // ...
    }
}

//测试revert+自定义错误和require用法一致
contract VendingMachine {
    address owner;
    error Unauthorized();
    function buy(uint amount) public payable {
        if (amount > msg.value / 2 ether)
            revert("Not enough Ether provided.");
            
        // 另一种做法：
        require(
            amount <= msg.value / 2 ether,
            "Not enough Ether provided."
        );
        // 执行购买。
    }
    function withdraw() public {
        if (msg.sender != owner)
            revert Unauthorized();

        payable(msg.sender).transfer(address(this).balance);
    }
}

//测试枚举的定义
contract PurchaseMeiJu {
    enum State { Created, Locked, Inactive } // 枚举
}

//测试结构体的定义
contract Ballot {
    struct Voter { // 结构
        uint weight; //uint默认是uint256
        bool voted;     //布尔类型，默认是false
        address delegate; //默认是0地址
        uint vote;
    }
}

//测试地址类型的成员变量
contract VariableTest{
   address payable x = payable(0);
   address myAddress = address(this);
   function test() public {
       if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);
   }
}

