// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;//(开源协议，确定版本)https://spdx.org/licenses/这是全网协议地址


//1、引入统一一个文件系统下的合约
//2、引入github上的合约
//3、通过包引用
import {HelloWorld} from "./Test.sol"; //本地目录下可以直接引用，也可以指定引用
//import {HellowWorld} from "@companyName/product/contract"; //一般通过这种方式来引用，主流的方式
//import "https://github.com/smartcontractkit/Web3_tutorial_Chinese/blob/main/lesson-2/HelloWorld.sol";  //直接引入线上的合约

//工厂合约，智能合约的工厂模式
//工厂模式在复杂的 dApp 中尤其有用，例如创建多种类型的代币、拍卖合约或其他需要多个实例的场景。
//通过工厂合约，你可以在一个合约中部署其他合约实例，从而提高代码的重用性和管理的灵活性。
//基本概念
//1、工厂合约: 一个合约，负责创建和管理其他合约实例。它包含用于部署新合约的函数。
//2、被创建的合约: 由工厂合约部署的合约实例，可以有自己的状态和功能。
//3、地址管理: 工厂合约通常会存储已创建合约的地址，方便后续的管理和查询。
//优点
//1、简化管理: 通过工厂合约集中管理多个合约实例。
//2、代码重用: 允许多个合约实例共享相同的逻辑。
//3、灵活性: 可以根据需要动态创建合约，适应不同的需求。
contract HellowWorldFactory{
    HelloWorld hw;
    HelloWorld[] hws;
    function   createHelloWorld() public {
            hw = new HelloWorld();
            hws.push(hw);
    }

    function getHelloWorldByIndex(uint256 _index) public view returns (HelloWorld) {
        return hws[_index];
    }

    function callSayHelloFromFactory(uint256 _index,uint256 _id) 
        public view  returns (string memory){
            return hws[_index].sayHello(_id);
    }

    function callSetHelloWorldFromFactory(uint256 _index,string memory newString,uint256 _id) public {
        return hws[_index].setHelloWorld(newString,_id);
    }
}


