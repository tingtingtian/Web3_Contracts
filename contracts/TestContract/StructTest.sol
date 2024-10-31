// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

// 定义一个具有两个字段的新类型。
// 在合约外部声明结构体允许它被多个合约共享。
// 在这里，这并不是必需的。
struct Funder {
    address addr;
    uint amount;
}

contract CrowdFunding {
    // 结构体也可以在合约内部定义，这使得它们仅在此处和派生合约中可见。
    struct Campaign {
        address payable beneficiary;
        uint fundingGoal;
        uint numFunders;
        uint amount;
        mapping(uint => Funder) funders;
    }

    uint numCampaigns;
    mapping(uint => Campaign) campaigns;

    function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID 作为一个变量返回
        // 不能使用 "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
        // 因为右侧创建了一个包含映射的内存结构 "Campaign"。
        Campaign storage c = campaigns[campaignID];
        c.beneficiary = beneficiary;
        c.fundingGoal = goal;
    }

    function contribute(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];
        // 创建一个新的临时内存结构，使用给定值初始化
        // 并将其复制到存储中。
        // 注意，你也可以使用 Funder(msg.sender, msg.value) 进行初始化。
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }

    function checkGoalReached(uint campaignID) public returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
}