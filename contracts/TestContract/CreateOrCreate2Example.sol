// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {
    uint256 public value;

    constructor(uint256 _value) {
        value = _value;
    }
}

contract CreateExample {
    event ContractCreated(address contractAddress);

    function createSimpleContract(uint256 _value) public {
        //第一次是：0x71010f13F37AB9A0dB58eA7B0a280800813702cF 
        //第二次是：0x641ff03Ae4d8cB6997bC60C63129d9Bb7438d06E
        //重新部署一次：0x6087c69272e6E5DED53B271ae01440F1997EF499
        SimpleContract newContract = new SimpleContract(_value);
        emit ContractCreated(address(newContract));
    }

    function createSimpleContractWithSalt(uint256 _value, bytes32 salt) public {
        // 使用 create2 部署合约
        address newContractAddress;
        bytes memory bytecode = abi.encodePacked(type(SimpleContract).creationCode, abi.encode(_value));
        
        assembly {
            //第一次是：0x0aB885814FDC7FA72EFDdF16472149d9Bb0A06dc
            //第二次直接revert啦
            //重新部署一次：0x9AF5405A28447790Cc59e47C9CcA22802C152B02
            //重新部署二次：0x4F645015B4A922b49D3c8CCEFd5563c191C9073d
            //重新部署三次：0x80c630365CF60aA40D033F4c98E7cf9BD28F0F71
            newContractAddress := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
            if iszero(newContractAddress) {
                revert(0, 0)
            }
        }
        emit ContractCreated(newContractAddress);
    }


    function getAddress(bytes memory bytecode, bytes32 salt) private view returns (address) {
        return address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(bytecode)
        )))));
    }

    function createSimpleContractWithSaltWithCheck(uint256 _value, bytes32 salt) public returns (address) {
        bytes memory bytecode = abi.encodePacked(type(SimpleContract).creationCode, abi.encode(_value));
        address newContractAddress = getAddress(bytecode, salt);

        require(!isContract(newContractAddress), "Contract already exists at this address");
        
        // 使用 create2 部署合约
        assembly {
            newContractAddress := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
            if iszero(newContractAddress) {
                revert(0, 0)
            }
        }
        emit ContractCreated(newContractAddress);
        return newContractAddress;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}