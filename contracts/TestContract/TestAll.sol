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

pragma solidity ^0.8.0;

contract Bank {
    address public owner; // 合约管理员
    mapping(address => uint256) private balances; // 用户余额
    bool public operational; // 合约运行状态

    // 自定义错误
    error NotAuthorized(address caller); // 未授权调用错误
    error InsufficientBalance(uint requested, uint available); // 余额不足错误

    // 事件
    event Deposit(address indexed user, uint amount);
    event Withdraw(address indexed user, uint amount);
    event FallbackTriggered(address sender, uint amount);

    constructor() {
        owner = msg.sender; // 部署者为合约管理员
        operational = true; // 默认开启
    }

    // 仅管理员调用的修饰符
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotAuthorized(msg.sender); // 使用自定义错误处理权限问题
        }
        _;
    }

    // 合约必须处于运行状态
    modifier isOperational() {
        require(operational, "Contract is not operational"); // 使用 require 检查运行状态
        _;
    }

    // 存款功能
    function deposit() external payable isOperational {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 提款功能
    function withdraw(uint256 amount) external isOperational {
        uint256 userBalance = balances[msg.sender];
        if (amount > userBalance) {
            revert InsufficientBalance(amount, userBalance); // 使用自定义错误处理余额不足
        }
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    // 查询用户余额
    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }

    // 暂停合约功能
    function pauseContract() external onlyOwner {
        operational = false;
    }

    // 恢复合约功能
    function resumeContract() external onlyOwner {
        operational = true;
    }

    // 使用 assert 检查合约状态
    function checkInvariant() external view onlyOwner {
        // 验证合约状态是否符合预期，例如总余额应大于 0
        uint totalBalance = address(this).balance;
        assert(totalBalance >= 0); // 逻辑上 totalBalance 不可能小于 0
    }

    // 调用外部合约的示例
    function externalCall(address target, uint256 amount) external onlyOwner {
        ExternalContract externalContract = ExternalContract(target);
        try externalContract.deposit{value: amount}() {
            // 调用成功
        } catch Error(string memory reason) {
            // 捕获 revert 的错误
            revert(reason);
        } catch {
            // 捕获其他未知错误
            revert("Unknown error during external call");
        }
    }

    // 回退函数，接收以太币
    receive() external payable {
        emit FallbackTriggered(msg.sender, msg.value);
    }

    // 用于未知调用的回退函数
    fallback() external payable {
        emit FallbackTriggered(msg.sender, msg.value);
    }
}

contract ExternalContract {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
    }
}

pragma solidity ^0.8.0;

/// @title 简单的 ERC20 代币实现
/// @dev 此合约实现了符合 ERC20 标准的所有必要方法。
contract MyERC20Token {
    // ---------------------------
    // ERC20 状态变量
    // ---------------------------

    // @dev 用于存储每个地址余额的映射
    mapping(address => uint256) private balances;

    // @dev 用于存储所有者为花费者设置的授权额度的映射
    mapping(address => mapping(address => uint256)) private allowances;

    // @dev 代币的总供应量
    uint256 private _totalSupply;

    // @dev 代币的基本信息
    string public name; // 代币名称
    string public symbol; // 代币符号
    uint8 public decimals; // 代币的小数位数

    // ---------------------------
    // 事件
    // ---------------------------

    // @dev 当代币被转移时触发的事件
    event Transfer(address indexed from, address indexed to, uint256 value);

    // @dev 当代币所有者为某个花费者设置授权额度时触发的事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ---------------------------
    // 构造函数
    // ---------------------------

    /// @dev 构造函数，用于初始化代币信息并铸造初始供应量
    /// @param _name 代币名称
    /// @param _symbol 代币符号
    /// @param _decimals 小数位数
    /// @param initialSupply 代币的初始供应量（以最小单位表示）
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _mint(msg.sender, initialSupply); // 将初始供应量铸造给合约部署者
    }

    // ---------------------------
    // ERC20 标准函数
    // ---------------------------

    /// @notice 返回代币的总供应量
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /// @notice 返回某个地址的代币余额
    /// @param account 要查询的地址
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    /// @notice 从调用者账户向指定地址转移代币
    /// @param recipient 接收代币的地址
    /// @param amount 要转移的代币数量
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /// @notice 返回某个花费者被授权的额度
    /// @param owner 代币所有者的地址
    /// @param spender 被授权花费代币的地址
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    /// @notice 授权某个地址为调用者花费指定数量的代币
    /// @param spender 被授权的地址
    /// @param amount 被授权的代币数量
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /// @notice 从一个地址向另一个地址转移代币（基于授权）
    /// @param sender 转出代币的地址
    /// @param recipient 接收代币的地址
    /// @param amount 转移的代币数量
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    // ---------------------------
    // 内部辅助函数
    // ---------------------------

    /// @dev 内部函数，用于在两个地址之间转移代币
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balances[sender] >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            balances[sender] -= amount;
            balances[recipient] += amount;
        }

        emit Transfer(sender, recipient, amount);
    }

    /// @dev 内部函数，用于批准花费者的额度
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /// @dev 内部函数，用于铸造新的代币
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    /// @dev 内部函数，用于销毁代币
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        require(balances[account] >= amount, "ERC20: burn amount exceeds balance");

        unchecked {
            balances[account] -= amount;
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }
}


pragma solidity ^0.8.0;

/// @title ERC721 NFT 实现
/// @dev 满足 ERC721 标准，并实现基本的 NFT 功能
contract MyERC721Token {
    // ------------------------------
    // ERC721 标准的状态变量
    // ------------------------------

    // @dev 映射：tokenId => 拥有者地址
    mapping(uint256 => address) private _owners;

    // @dev 映射：地址 => 其拥有的 NFT 数量
    mapping(address => uint256) private _balances;

    // @dev 映射：tokenId => 授权地址
    mapping(uint256 => address) private _tokenApprovals;

    // @dev 映射：地址 => （操作员地址 => 是否被授权）
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // @dev NFT 名称
    string public name;

    // @dev NFT 符号
    string public symbol;

    // ------------------------------
    // ERC721 事件
    // ------------------------------

    // @dev 当 token 转移时触发事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // @dev 当 token 授权时触发事件
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // @dev 当操作员被设置或移除时触发事件
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // ------------------------------
    // 构造函数
    // ------------------------------

    /// @dev 初始化 NFT 名称和符号
    /// @param _name NFT 名称
    /// @param _symbol NFT 符号
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    // ------------------------------
    // ERC721 标准函数实现
    // ------------------------------

    /// @notice 查询地址拥有的 NFT 数量
    /// @param owner 查询的地址
    /// @return balance NFT 数量
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /// @notice 查询 tokenId 的拥有者
    /// @param tokenId 查询的 tokenId
    /// @return owner 拥有者地址
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /// @notice 安全转移 NFT（需要目标地址支持 ERC721 接口）
    /// @param from 当前拥有者地址
    /// @param to 接收者地址
    /// @param tokenId 转移的 tokenId
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId);
    }

    /// @notice 转移 NFT（不检查目标地址是否支持 ERC721）
    /// @param from 当前拥有者地址
    /// @param to 接收者地址
    /// @param tokenId 转移的 tokenId
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: caller is not token owner or approved");
        _transfer(from, to, tokenId);
    }

    /// @notice 授权地址可以管理指定的 tokenId
    /// @param to 授权地址
    /// @param tokenId 授权的 tokenId
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }

    /// @notice 查询 tokenId 的授权地址
    /// @param tokenId 查询的 tokenId
    /// @return operator 授权地址
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "ERC721: invalid token ID");
        return _tokenApprovals[tokenId];
    }

    /// @notice 设置或移除操作员
    /// @param operator 操作员地址
    /// @param approved 是否授权
    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /// @notice 查询是否已授权操作员
    /// @param owner 拥有者地址
    /// @param operator 操作员地址
    /// @return 是否授权
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    // ------------------------------
    // 内部和私有函数
    // ------------------------------

    /// @dev 转移 NFT 的内部实现
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        // 清除之前的授权
        _approve(address(0), tokenId);

        // 更新持有数量
        _balances[from] -= 1;
        _balances[to] += 1;

        // 更新 tokenId 拥有者
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /// @dev 授权地址的内部实现
    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    /// @dev 判断调用者是否是拥有者或被授权的地址
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /// @dev 查询 tokenId 是否存在
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /// @dev 安全转移的内部实现
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        _transfer(from, to, tokenId);
        // 此处可以扩展，调用目标地址的 onERC721Received 检查
    }

    /// @dev 铸造新 NFT
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
}