// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 定义一个合约
contract ExampleContract {

    // 1. 数据类型关键字
    uint256 public count; // 无符号整型，用于存储计数
    bool public isActive = true; // 布尔型，用于判断状态
    string public name; // 字符串，用于存储名称
    address public owner; // address类型，用于存储合约拥有者的地址
    bytes32 public dataHash; // bytes类型，用于存储数据的哈希值

    // 2. enum 枚举类型
    enum Status { Pending, Active, Inactive }
    Status public currentStatus;

    // 3. struct 定义结构体类型
    struct User {
        uint id;
        string name;
    }

    // 4. array 和 mapping 定义数组和映射
    User[] public users; // 用户结构体的数组
    mapping(address => uint) public balances; // 地址到余额的映射

    // 5. modifier 修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    // 6. event 事件，用于日志记录
    event UserAdded(uint id, string name);
    event BalanceUpdated(address indexed user, uint balance);

    // 7. 构造函数，用于初始化合约
    constructor(string memory _name) {
        owner = msg.sender; // msg.sender 表示当前交易的发送者地址
        name = _name;
        currentStatus = Status.Pending;
    }

    // 8. payable 可支付的函数，允许接收以太币
    function deposit() public payable {
        require(msg.value > 0, "Must send some ether");
        balances[msg.sender] += msg.value; // 更新余额
        emit BalanceUpdated(msg.sender, balances[msg.sender]); // 触发事件
    }

    // 9. public, view 函数，用于查看余额
    function getBalance(address _user) public view returns (uint) {
        return balances[_user];
    }

    // 10. pure 函数，用于纯计算
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    // 11. external 函数，仅能外部调用
    function setActiveStatus() external onlyOwner {
        currentStatus = Status.Active;
    }

    // 12. internal 函数，仅限内部调用
    function _resetCount() internal {
        count = 0;
    }

    // 13. private 函数，仅限当前合约内部调用
    function _generateHash(string memory _data) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(_data));
    }

    // 14. 循环与条件语句示例
    function addUser(string memory _name) public onlyOwner {
        // 计算新的用户 ID
        uint id = users.length + 1;
        users.push(User(id, _name)); // 将新用户添加到数组
        emit UserAdded(id, _name); // 触发事件

        // 检查数据哈希
        dataHash = _generateHash(_name); // 计算字符串的哈希值

        // 使用循环查找特定用户
        for (uint i = 0; i < users.length; i++) {
            if (keccak256(abi.encodePacked(users[i].name)) == dataHash) {
                break; // 找到匹配的用户并退出循环
            }
        }
    }

    // 15. fallback 和 receive 函数，允许合约接收以太币
    fallback() external payable {
        deposit(); // 当合约接收到以太币时，调用 deposit 函数
    }
    
    receive() external payable {
        deposit(); // receive 函数，当接收以太币时自动触发
    }

    // 示例函数，只有合约在活动状态时才可调用
    function doSomething() public view returns (string memory) {
        require(isActive, "Contract is inactive");
        return "Contract is active and doing something!";
    }

    // 16. 删除函数，销毁合约并转移余额
    function close() public onlyOwner {
        isActive = false; // 设置合约为非活动状态，限制功能调用
        payable(owner).transfer(address(this).balance); // 将余额发送给拥有者
    }

    // 17. 使用 inline assembly 编写底层代码
    function getCodeSize(address _addr) public view returns (uint size) {
        assembly {
            size := extcodesize(_addr) // 获取指定地址的代码大小
        }
    }
}