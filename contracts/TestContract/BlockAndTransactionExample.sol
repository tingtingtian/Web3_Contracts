// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockAndTransactionExample {

    // 存储信息的事件，用于方便观察链上结果
    event BlockInfo(
        bytes32 blockHash,
        //bytes32 blobHash,
        uint baseFee,
        //uint blobBaseFee,
        uint chainId,
        address coinbase,
        //uint difficulty,
        uint gasLimit,
        uint blockNumber,
        uint prevrandao,
        uint timestamp
    );

    event TransactionInfo(
        uint gasLeft,
        bytes data,
        address sender,
        bytes4 sig,
        uint value,
        uint gasPrice,
        address origin
    );

    // 获取区块相关信息
    function getBlockInfo(uint blockNumber) public {
        // 获取给定区块的哈希（仅适用于最近256个区块）
        bytes32 blockHash = blockhash(blockNumber);
        
        // 获取当前交易关联的 blob 的哈希（EIP-4844）
        //bytes32 blobHash = blobhash(blobIndex);
        
        // 获取当前区块的基础费用（EIP-3198 和 EIP-1559）
        uint baseFee = block.basefee;
        
        // 获取当前区块的 blob 基础费用（EIP-7516 和 EIP-4844）
        //uint blobBaseFee = block.blobbasefee;
        
        // 获取当前链的链ID
        uint chainId = block.chainid;
        
        // 获取当前区块矿工的地址
        address coinbase = block.coinbase;
        
        // 获取当前区块的难度（在 Paris 之前的 EVM 版本有效）
        //uint difficulty = block.difficulty;
        
        // 获取当前区块的 gas 限制
        uint gasLimit = block.gaslimit;
        
        // 获取当前区块的编号
        uint blockNumberCurrent = block.number;
        
        // 获取当前区块的由信标链提供的随机数（EVM >= Paris）
        uint prevrandao = block.prevrandao;
        
        // 获取当前区块的时间戳（Unix 时间戳）
        uint timestamp = block.timestamp;
        
        // 触发事件，记录所有区块相关信息
        emit BlockInfo(blockHash, baseFee, chainId, coinbase, gasLimit, blockNumberCurrent, prevrandao, timestamp);
    }

    // 获取交易和消息相关信息
    function getTransactionInfo() public payable {
        // 获取剩余的 gas
        uint gasLeft = gasleft();
        
        // 获取完整的 calldata
        bytes calldata data = msg.data;
        
        // 获取消息的发送者（当前调用者）
        address sender = msg.sender;
        
        // 获取 calldata 的前四个字节（函数选择器）
        bytes4 sig = msg.sig;
        
        // 获取与消息一起发送的 wei 数量
        uint value = msg.value;
        
        // 获取交易的 gas 价格
        uint gasPrice = tx.gasprice;
        
        // 获取交易的发送者地址（完整调用链中的原始调用者）
        address origin = tx.origin;
        
        // 触发事件，记录所有交易相关信息
        emit TransactionInfo(gasLeft, data, sender, sig, value, gasPrice, origin);
    }
}