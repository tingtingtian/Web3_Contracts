// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 合约的部署者、筹款人、投资人的权限控制
contract Crowdfunding {
    address public owner;             // 合约的部署者（管理员）
    address public fundraiser;        // 筹款人
    uint public goal;                 // 筹款目标
    uint public deadline;             // 筹款截止时间
    uint public totalRaised;          // 当前筹集到的总金额
    mapping(address => uint) public contributions; // 每个投资人的捐款金额

    // 定义合约的状态
    enum FundraisingStatus { Ongoing, Successful, Failed }
    FundraisingStatus public status;

    // 修饰符：只有合约部署者才能调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 修饰符：只有筹款人才能调用
    modifier onlyFundraiser() {
        require(msg.sender == fundraiser, "Only fundraiser can call this function");
        _;
    }

    // 修饰符：确保筹款活动正在进行
    modifier ongoing() {
        require(status == FundraisingStatus.Ongoing, "Fundraising is not ongoing");
        require(block.timestamp < deadline, "Fundraising has ended");
        _;
    }

    // 构造函数，初始化合约
    constructor(address _fundraiser, uint _goal, uint _duration) {
        owner = msg.sender;  // 合约部署者为合约的所有者
        fundraiser = _fundraiser;  // 设置筹款人
        goal = _goal;  // 筹款目标
        deadline = block.timestamp + _duration;  // 筹款的截止时间
        status = FundraisingStatus.Ongoing;  // 设置为筹款进行中
    }

    // 投资人向合约捐款
    function contribute() public payable ongoing {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    // 筹款人提取资金（筹款成功后才能提取）
    function withdrawFunds() public onlyFundraiser {
        require(totalRaised >= goal, "Fundraising goal not reached");
        require(status == FundraisingStatus.Ongoing, "Cannot withdraw in current state");
        status = FundraisingStatus.Successful;
        payable(fundraiser).transfer(totalRaised);
    }

    // 投资人撤回资金（筹款失败时可撤回）
    function refund() public {
        require(block.timestamp > deadline, "Fundraising is still ongoing");
        require(totalRaised < goal, "Fundraising was successful");
        require(contributions[msg.sender] > 0, "No contributions to refund");

        uint amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // 合约所有者可以提前终止筹款
    function terminateFundraising() public onlyOwner {
        require(status == FundraisingStatus.Ongoing, "Fundraising is not ongoing");
        status = FundraisingStatus.Failed;
    }
}
