// SPDX-License-Identifier: MIT
// ContractB: 提供 setValue 函数
pragma solidity ^0.8.0;

contract ContractB {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}

// ContractA: 调用 ContractB 中的 setValue 函数
pragma solidity ^0.8.0;

contract ContractA {
    address contractBAddress;

    constructor(address _contractBAddress) {
        contractBAddress = _contractBAddress;
    }

    function setContractBValue(uint256 _value) public {
        ContractB(contractBAddress).setValue(_value);
    }
}

pragma solidity ^0.8.0;

contract ContractC {
    address payable targetContract;

    constructor(address payable _targetContract) {
        targetContract = _targetContract;
    }

    function transferEther() public payable {
        // 使用 transfer 发送以太币
        targetContract.transfer(msg.value);
    }
}

// Contract B (没有 receive 或 fallback 函数)
pragma solidity ^0.8.0;

contract ContractD {
    // 没有 receive 或 fallback 函数
}

pragma solidity ^0.8.0;

contract TargetContract {
    // 通过 payable 函数接收以太币
    uint public balance;

    function deposit() external payable returns(uint){
        // 增加合约的余额
        balance += msg.value;
        return balance;
    }
}

contract CallerContract {
    TargetContract public target;

    constructor(address targetAddress) payable  {
        target = TargetContract(targetAddress);
    }

    // 使用 call 调用 deposit() 函数
    function sendEther() external payable {
        // 使用 low-level call 方式调用目标合约的 deposit 函数
        uint256 balance =msg.value;
        (bool success, ) = address(target).call{value:balance}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "Call failed");
    }

}

pragma solidity ^0.8.0;

contract TargetContract2 {
    uint public balance;

    // 通过 payable 函数接收以太币
    function deposit() external payable returns(uint) {
        // 增加合约的余额
        balance += msg.value;
        return balance;
    }
}
//0xa42b1378D1A84b153eB3e3838aE62870A67a40EA
contract CallerContract2 {
    TargetContract2 public target;

    constructor(address targetAddress) payable {
        target = TargetContract2(targetAddress);
    }

    // 使用 call 调用 deposit() 函数，并传递以太币，这里的msg.value的值是0，一定要注意
    function sendEther() external payable {
        // 使用 low-level call 方式调用目标合约的 deposit 函数，并传递以太币
        uint256 balance =msg.value;
        (bool success, ) = address(target).call{value:balance}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "Call failed");
    }

        // 使用手动设置的值发送以太币
    function sendFixedAmount() external  {
        // 使用 low-level call 方式调用目标合约的 deposit 函数，手动指定转账 1 ether
        (bool success, ) = address(target).call{value: 100}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "Call failed");
    }

     // 将所有合约余额转移到目标合约
    function sendAllEther() external {
        uint256 amountToSend = address(this).balance; // 获取当前合约的所有以太币余额
        require(amountToSend > 0, "No Ether to send");

        // 使用 low-level call 调用目标合约的 deposit 函数，并转移以太币
        (bool success, ) = address(target).call{value: amountToSend}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "Failed to transfer Ether");
    }

}

// Contract A
pragma solidity ^0.8.0;

contract ContractE {
    address payable targetContract;

    constructor(address payable _targetContract) payable {
        targetContract = _targetContract;
    }

    function callEther() public payable {
        // 使用 call 发送以太币
        (bool success, ) = targetContract.call{value: msg.value}("");
        require(success, "Transfer failed");
    }
}

// Contract B (没有 receive 或 fallback 函数)
pragma solidity ^0.8.0;

contract ContractF {
    // 没有 receive 或 fallback 函数
}

pragma solidity ^0.8.0;

interface IContract {
    function getBalance(address account) external view returns (uint256);
}

contract QueryContract {
    IContract public contractAddress;

    constructor(address _contract) {
        contractAddress = IContract(_contract);
    }

    function queryBalance(address account) public view returns (uint256) {
        (bool success, bytes memory data) = address(contractAddress).staticcall(
            abi.encodeWithSignature("getBalance(address)", account)
        );
        require(success, "Staticcall failed");

        (uint256 balance) = abi.decode(data, (uint256));
        return balance;
    }
}