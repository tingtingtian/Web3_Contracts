
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

//用于验证合约在etherscan里面的验证和部署，让其它用户可以看到源码，在这里可以直接调用合约
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/interfaces/draft-IERC6093.sol


// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/draft-IERC6093.sol)
pragma solidity ^0.8.20;

/**
 * @dev Standard ERC20 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC20 tokens.
 */
interface IERC20Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC20InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC20InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     * @param allowance Amount of tokens a `spender` is allowed to operate with.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC20InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC20InvalidSpender(address spender);
}

/**
 * @dev Standard ERC721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC721 tokens.
 */
interface IERC721Errors {
    /**
     * @dev Indicates that an address can't be an owner. For example, `address(0)` is a forbidden owner in EIP-20.
     * Used in balance queries.
     * @param owner Address of the current owner of a token.
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev Indicates a `tokenId` whose `owner` is the zero address.
     * @param tokenId Identifier number of a token.
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev Indicates an error related to the ownership over a particular token. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param tokenId Identifier number of a token.
     * @param owner Address of the current owner of a token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC721InvalidOperator(address operator);
}

/**
 * @dev Standard ERC1155 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC1155 tokens.
 */
interface IERC1155Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     * @param tokenId Identifier number of a token.
     */
    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC1155InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC1155InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
    error ERC1155MissingApprovalForAll(address operator, address owner);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC1155InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC1155InvalidOperator(address operator);

    /**
     * @dev Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
     * Used in batch transfers.
     * @param idsLength Length of the array of token identifiers
     * @param valuesLength Length of the array of token amounts
     */
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.20;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 */
abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, lowering the total supply.
     * Relies on the `_update` mechanism.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead
     */
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Overrides to this logic should be done to the variant with an additional `bool emitEvent` argument.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    /**
     * @dev Variant of {_approve} with an optional flag to enable or disable the {Approval} event.
     *
     * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
     * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
     * `Approval` event during `transferFrom` operations.
     *
     * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to
     * true using the following override:
     * ```
     * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
     *     super._approve(owner, spender, value, true);
     * }
     * ```
     *
     * Requirements are the same as {_approve}.
     */
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `value`.
     *
     * Does not update the allowance value in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Does not emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

// File: @chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

// solhint-disable-next-line interface-starts-with-i
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: contracts/StudyContract1001/FundMe.sol


pragma solidity ^0.8.20;

//预言机通过调用外部 API、物联网设备或数据库等数据源，将实时数据引入区块链，
//并通过主动推送、请求-响应、事件触发等机制实现数据更新。
//去中心化的预言机网络能够通过多方验证、数据聚合和共识机制，确保数据的准确性、可靠性和安全性，
//从而支持各种去中心化应用（如 DeFi、保险、供应链等）的顺利运行。


// EOA 账户 是用户通过钱包创建的账户，无法直接在 Solidity 中定义，它们是以太坊网络上的外部账户，代表用户或实体。
// 合约账户 是通过部署智能合约生成的，在 Solidity 中通过编写智能合约代码定义，当合约部署后会生成一个唯一的合约地址。

//1、创建收款函数(让函数有收款功能需要payable)
//2、记录投资人并查看
//3、锁定期限内，达到目标值，生产商可以提款
//4、在锁定期内，没有达到目标值，投资人在锁定期后可以退款
contract FundMe {
    mapping (address => uint256) public fundersToAmount;

    AggregatorV3Interface internal dataFeed;
    //设置最小额度，方便管理
    uint256 constant MINIMUM_VALUE = 100 * 10 ** 18 ;//单位是USD

    //设置筹集目标值
    uint256 constant TARGET = 1000 * 10 ** 18;

    //合约所有者
    address public owner;

    //部署的时间，设计锁定期限，没有date类、时间戳等
    uint256 deploymentTimesstamp;
    //锁定时间
    uint256 lockTime;

    //申明ERC20的地址
    address erc20Addr;

    bool public  getFundSuccess = false;

    modifier windowClosed() { 
        require(block.timestamp>=deploymentTimesstamp+lockTime,"window is not close");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"this function can only be called by owner");
        _;
    }

    constructor(uint256 _lockTime) {
        //sepolia testnet
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        owner = msg.sender;
        deploymentTimesstamp = block.timestamp;
        lockTime = _lockTime;
    }

    function setFunderToAmount(address funder,uint256 amountToUpdate) external {
        require(msg.sender == erc20Addr,"You do not have permission to call this function");
        fundersToAmount[funder] = amountToUpdate;
    }

    function setErc20Addr(address _erc20Addr) public onlyOwner{
        erc20Addr = _erc20Addr;
    }

    //如果以美元USD来计价的话，需要知道现在ETH的价格，需要引入预言机----链上和链下数据的交互
    function fund() external  payable {
        require(convertEthToUsd(msg.value)>= MINIMUM_VALUE,"Send more ETH"); //如果不满足条件会被revert掉
        require(block.timestamp<deploymentTimesstamp+lockTime,"window is close");
        fundersToAmount[msg.sender] = msg.value;
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethAmount) internal view  returns(uint256){
        uint256 ethPrice =uint256(getChainlinkDataFeedLatestAnswer());
        return  ethAmount * ethPrice /(10**8);
    }

    function transferOwnerShip(address newOwner) public  onlyOwner{ //设置捐赠的时候，哪一步把所有权转到发起人好？
        //require(msg.sender == owner,"this function can only be called by owner");
        owner = newOwner;
    }

    function getFund() external windowClosed onlyOwner{
        require(convertEthToUsd(address(this).balance) >= TARGET,"Target is not reacherd");
        //require(block.timestamp>=deploymentTimesstamp+lockTime,"window is not close");
        //require(msg.sender == owner ,"this function can only be called by owner");
        //有三个转账函数
        //1、transfer:transfer ETH and revert if tx failed（是最简单、最常用的方法）
        
        //将智能合约中当前持有的全部以太币余额转账给当前的调用者（msg.sender）。
        //常见的使用场景是当合约完成某个操作后，将合约中的资金归还给用户，或是执行某种退款逻辑
        //payable 关键字表示某个地址可以接收以太币。Solidity 中，地址有两种类型：address 和 address payable，其中 address payable 可以进行资金转账。
        //通过payable(msg.sender) 将 msg.sender 转换为 payable 类型，使得该地址能够接收以太币。
        //payable(msg.sender).transfer(address(this).balance);
        
        //2、send:transfer ETH and return false if failed,send、transfer、call是否会消耗gas
        //bool success = payable(msg.sender).send(address(this).balance);
        //require(success,"tx failed");

        //3、call:以太坊官方推荐的，transfer ETH with data return value of function and bool
        //aadr.call("fund") //调用fund函数
        //addr.call{value: value}("fund") //捐款多少
        (bool success, ) = payable (msg.sender).call{value:address(this).balance}("");
        require(success,"tx failed");
        //把账户归零
        fundersToAmount[msg.sender]=0;
        getFundSuccess = true;


        //详细对比：send、transfer、call是否会消耗gas
        //操作方式	成功时的gas 消耗   失败时的 gas 消耗	错误处理机制
        //send	   固定 2300 gas	固定 2300 gas	    返回 false，需要手动处理
        //transfer 固定 2300 gas	固定 2300 gas	    抛出异常，自动回退
        //call	   可自定义 gas	     消耗所有提供的 gas	   返回 false，需要手动处理
        //结论：
        // send 和 transfer 操作失败时，只会消耗固定的 2300 gas。
        // call 操作失败时，会消耗掉你为其提供的所有 gas，因此相对来说风险更大，需要仔细处理返回值以避免大量 gas 损失。

        // 全方位对比
        // 安全性: transfer > send > call，安全性上transfer是最高的，因为它会在失败时回滚。
        // 灵活性: call > send > transfer，灵活性上call提供了最高的灵活性，可以调用合约的函数，定制化程度高。
        // 推荐使用：目前社区推荐使用call，因为它灵活性和兼容性，但同时需要确保正确的错误处理机制。
        // Gas消耗：transfer和send虽然安全性较高由于其限制gas消耗到2300，但这限制了它们的灵活性和适应性，
        // 比方说不适合在需要一些复杂计算或多步操作的场合。而call虽提供极高灵活性和功能强大的控制，
        // 但同时带来了更高的风险，需要开发者手动管理这些风险。
    }

    function refund() external windowClosed {
        require(convertEthToUsd(address(this).balance) < TARGET,"Target is reacherd");
        require(fundersToAmount[msg.sender]!=0,"there is no fund for you");
        //require(block.timestamp>=deploymentTimesstamp+lockTime,"window is not close");
        //require(fundersToAmount[msg.sender]<=);
        (bool success,) = payable (msg.sender).call{value:fundersToAmount[msg.sender]}("");
        require(success,"tx failed");
        //把账户归零
        fundersToAmount[msg.sender]=0;
    }
        // 个人理解：Solidity 编程可以理解为一种 面向多用户、多角色 的编程模式。
        // 1. 多用户（Multi-User）编程
        // 在区块链上，每个地址代表一个用户或智能合约。不同用户通过地址相互交互，而 Solidity 智能合约允许多个用户与合约交互。
        // msg.sender: Solidity 合约中的 msg.sender 代表调用合约的用户地址，智能合约函数的行为通常会根据 msg.sender 的不同来决定。
        // 去中心化的用户交互：智能合约是公开的，任何人都可以调用它的公共函数。因此，合约的开发必须考虑到多个用户对同一个合约的并发访问，以及如何根据不同用户执行不同逻辑。
        // 权限管理：不同用户可能具有不同的权限，合约开发通常需要为用户设置角色和权限，控制用户能够调用哪些函数。例如，某些函数可能只允许合约的所有者或管理员执行。

        //2. 多角色（Multi-Role）编程
        // Solidity 合约经常需要区分不同角色的权限，并根据用户的角色来执行不同的操作。
        // 这可以通过角色管理、访问控制等机制来实现。角色的概念允许开发者设计复杂的权限体系，使得不同用户能够执行不同的操作。

        // 基于角色的访问控制：可以使用像 OpenZeppelin 提供的 AccessControl 模块来定义和管理不同的角色。例如，一个去中心化应用（DApp）中可能存在多个角色：
        // 管理员角色：能够管理其他用户的权限。
        // 普通用户角色：只能使用合约的某些功能。
        // 特殊角色：例如拍卖合约中的竞拍者、卖家和买家，或者众筹合约中的项目发起者和投资者。

        //3. 角色和用户的动态交互
        // 智能合约在区块链上是动态的，用户和角色的关系可以随时发生变化。
        // 合约中可以编写逻辑，允许角色动态变更。例如，一个普通用户可以在满足特定条件后成为管理员，
        // 或一个竞拍者在竞拍成功后成为拍卖赢家。

        // 4. 应用场景
        // 以下是一些应用场景，展现了 Solidity 如何支持多用户、多角色的编程模式：

        // 投票系统：区分投票者、管理员、候选人等不同角色。投票者可以投票，管理员可以管理候选人和投票过程。
        // 众筹平台：有项目发起人、投资者等角色。投资者可以根据项目状态选择投资，发起人可以管理项目资金使用。
        // 去中心化交易所：用户可以有买家、卖家等不同角色，不同的角色具有不同的权限和行为。
        
        // 总结
        // 在 Solidity 编程中，由于区块链是去中心化的环境，任何用户都可以与智能合约交互，
        // 因此可以认为 Solidity 编程是面向多用户的。而通过访问控制和角色管理机制，
        //合约中能够区分不同用户的权限和行为，使其成为面向多角色编程的一种模式。
        //因此，理解 Solidity 编程时，可以将其视为多用户、多角色的交互编程模式。
}
// File: contracts/StudyContract1001/FundTokenERC20.sol


pragma solidity ^0.8.20;

//FundMe
//1、让FundMe的参与者，基于mapping来领取相应数量的通证
//2、让FundMe的参与者，tranfer通证
//3、在使用完成后，需要burn通证



contract FundTokenERC20 is ERC20{
    FundMe fundMe;
    constructor(address fundMeAddr) ERC20("FundTokenERC20","FT"){
        fundMe = FundMe(fundMeAddr);
    }

    function mint(uint256 amountToMint) public {
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint,"You cannot mint this many tokens");
        require(fundMe.getFundSuccess(),"The fundMe is not completed yet");
        _mint(msg.sender,amountToMint);
        fundMe.setFunderToAmount(msg.sender, fundMe.fundersToAmount(msg.sender)-amountToMint);
    }

    function claim(uint256 amountToClaim) public {
        //compelte claim
        require(balanceOf(msg.sender) >= amountToClaim,"You dont have enough ERC20 tokens");
        //burn ammountToClaim Tokens
        _burn(msg.sender, amountToClaim);

    }
}