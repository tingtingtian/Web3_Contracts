// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CustomProtocolExample
 * @dev 示例展示如何使用 ABI 自定义协议数据封装和解析
 */
contract CustomProtocolExample {

    struct Trade {
        uint256 itemId;       // 商品唯一 ID
        address buyer;        // 买家地址
        address seller;       // 卖家地址
        uint256 price;        // 商品价格
        string description;   // 商品描述
    }

    // 存储封装后的数据
    mapping(uint256 => bytes) public tradesData;

    /**
     * @dev 使用 ABI 编码封装交易数据
     * @param trade 交易信息结构体
     * @return encodedData ABI 编码后的二进制数据
     */
    function encodeTrade(Trade memory trade) public pure returns (bytes memory encodedData) {
        return abi.encode(trade.itemId, trade.buyer, trade.seller, trade.price, trade.description);
    }

    /**
     * @dev 解码封装的交易数据
     * @param data ABI 编码的二进制数据
     * @return trade 解码后的交易结构体
     */
    function decodeTrade(bytes memory data) public pure returns (Trade memory trade) {
        (
            uint256 itemId,
            address buyer,
            address seller,
            uint256 price,
            string memory description
        ) = abi.decode(data, (uint256, address, address, uint256, string));
        
        trade = Trade(itemId, buyer, seller, price, description);
    }

    /**
     * @dev 存储交易数据
     * @param trade 交易信息结构体
     */
    function storeTradeData(Trade memory trade) public {
        // 使用 itemId 作为主键存储封装后的数据
        tradesData[trade.itemId] = encodeTrade(trade);
    }

    /**
     * @dev 获取并解码交易数据
     * @param itemId 商品唯一 ID
     * @return trade 解码后的交易结构体
     */
    function getTradeData(uint256 itemId) public view returns (Trade memory trade) {
        bytes memory data = tradesData[itemId];
        require(data.length > 0, "Trade data not found");
        return decodeTrade(data);
    }
}