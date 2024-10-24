// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;//(开源协议，确定版本)https://spdx.org/licenses/这是全网协议地址

//基础数据类型
//struct:结构体
//array:数组
//mapping:映射
contract HelloWorld{

    // bool boolVar_1 = true;
    // bool boolVar_2 = true;

    // uint8 0-(2^8-1);   //(代表0-255)
    // uint256 0-(2^256-1);
    // uint = uint256;
    // uint8 uintVar = 255;

    // int256 intVar = -1;

    // bytes32 bytesVar = "Hello World" ;
    //bytes和bytes32是两个东西，bytes是数组

    //动态分配的bytes，在合约中声明的，属于storage变量，不需要写storage里面，编译器足够智能
    string strVar =  "Hello World" ;

    //address addrVar = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    struct Info{
        string phrase;
        uint256 id;
        address addr;
    }

    //数组
    Info[] infos;

    //mapping
    mapping (uint256 id => Info info) infoMapping;


    //sayHello() 后面是可调用标识符
    //public  合约内部、外部、子合约以及外部账户都可以访问
    //private 只有合约内部可以访问
    //internal 合约内部、子合约可以访问
    //external 合约外部，外部账户可以访问

    //view只对变量进行读取，不会对变量进行修改
    //view 用于读取状态，不修改；pure 不读取也不修改状态。（这里的状态可以指全局变量）
    function sayHello(uint256 _id) public view  returns (string memory){
        //第一次开发。return strVar;
        
        //第二次改进 for (uint256 i = 0; i<infos.length;i++ ){//这里用for循环在消息量很大的情况下，计算会越来越费钱
        //     if(infos[i].id == _id) {
        //         return addInfo(infos[i].phrase);
        //     }
        // }
        //return addInfo(strVar);

        //第三次改进 infoMapping[_id].phrase;//得到是一个string,判断string==""
        if (infoMapping[_id].addr == address(0x0)){
             return addInfo(strVar);
        }else{
            return addInfo(infoMapping[_id].phrase);
        }
    }



    /* 六种存储模式，不管变量的申明还是参数的传递都会落到这六种模式中的其中一种里面，
    编译器可以判断uint\bytes32\int这些简单的数据类型的存储结构，不需要加类似于memory和calldata的关键字
        1.storage  永久性存储
        2.memory   暂时性存储，这种在运行时数据是可以修改的，一般用于函数的入参且需要修改的时候，
        3.calldata 暂时性存储，这种在运行时数据时不可以修改的，一般用于函数的入参且不需要修改的时候
        4.stack
        5.codes
        6.logs
    */
    //修改变量的值
    function setHelloWorld(string memory newString,uint256 _id) public {
        //strVar = newString;
        Info memory info = Info(newString,_id,msg.sender);
        //infos.push(info);
        infoMapping[_id] = info;
    }
    //pure纯运算操作，没有状态的改变,也就是没有对全局变量的操作权限
    function addInfo(string memory helloWorldStr) internal  pure  returns(string memory){
       return  string.concat(helloWorldStr,",from tina's contract.");
    }
}