// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
	•	abi.encodePacked：无法直接用 abi.decode 解码，需根据数据结构手动解析。
	•	abi.encodeWithSelector 和 abi.encodeWithSignature：可使用 abi.decode，但需要跳过前 4 字节的选择器。
*/
contract ABIExample {

    function encodeData(uint256 a) public view  returns (bytes memory) {
        // 编码为标准 ABI 格式（32 字节对齐）
        return abi.encode(a, msg.sender);
    }
    function decodeData(bytes memory data) public pure returns (uint256, address) {
        // 解码为原始数据类型
        return abi.decode(data, (uint256, address));
    }
    function example() public pure returns (uint256, address) {
        bytes memory encoded = abi.encode(100, address(0x1234567890123456789012345678901234567890));
        return decodeData(encoded);
    }
    

    function encodePackedData(uint256 a, uint128 b) public pure returns (bytes memory) {
        // 紧密编码数据（不对齐到32字节）
        return abi.encodePacked(a, b);
    }
    function hashData(uint256 a, address b) public pure returns (bytes32) {
        // 计算紧密编码数据的哈希
        return keccak256(abi.encodePacked(a, b));
    }
    function decodePackedData(bytes memory data) public pure returns (uint256 a, uint128 b) {
        require(data.length == 32 + 16, "Invalid data length");

        // 手动解码，每段数据的长度需要事先知道
        assembly {
            a := mload(add(data, 32))
            b := mload(add(data, 48))
        }
    }

    function encodeWithSelector(address target, uint256 value) public pure returns (bytes memory) {
        // 使用函数选择器和参数进行编码
        return abi.encodeWithSelector(bytes4(keccak256("transfer(address,uint256)")), target, value);
    }

    function decodeSelectorData(bytes memory data) public pure returns (address target, uint256 value) {
        // 确保数据包含选择器和参数
        require(data.length >= 4, "Invalid data length");

        // 使用内联汇编来跳过前 4 字节
        assembly {
            // 调整 data 指针，使其指向编码数据的第五个字节
            target := mload(add(data, 36)) // data 起始位置 + 4 (跳过选择器) + 32 (起始偏移)
            value := mload(add(data, 68))  // 同上，并再加上 32 字节
        }
    }


    function encodeWithSignature(address target, uint256 value) public pure returns (bytes memory) {
        // 使用函数签名和参数进行编码
        return abi.encodeWithSignature("transfer(address,uint256)", target, value);
    }
    function decodeSignatureData2(bytes memory data) public pure returns (address target, uint256 value) {
        require(data.length >= 4, "Invalid data length");

        // 使用内联汇编直接跳过前4字节
        assembly {
            // 将 data 的指针偏移 4 字节，传递给 abi.decode
            target := mload(add(data, 36)) // 跳过 4 字节选择器和 32 字节偏移指针
            value := mload(add(data, 68))  // 跳过 4 字节选择器、32 字节偏移指针和 32 字节的第一个参数
        }
    }
    function decodeSignatureData(bytes memory data) public pure returns (address target, uint256 value) {
       require(data.length >= 4, "Invalid data length");

        // 创建一个新的 bytes 数组来存储跳过选择器后的数据
        bytes memory paramData = new bytes(data.length - 4);

        // 复制数据，从第5字节开始复制（跳过前4字节）
        for (uint256 i = 0; i < paramData.length; i++) {
            paramData[i] = data[i + 4];
        }

        // 使用 abi.decode 解码新生成的 bytes 数据
        return abi.decode(paramData, (address, uint256));
    }
   
}