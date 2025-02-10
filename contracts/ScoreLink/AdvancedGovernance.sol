// SPDX-License-Identifier: MIT
// 兼容 OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

// 导入 OpenZeppelin 的治理模块
import "@openzeppelin/contracts/governance/Governor.sol";  // 治理的核心功能
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";  // 治理设置，如投票延迟和周期
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";  // 简单的计票方式
import "@openzeppelin/contracts/governance/extensions/GovernorStorage.sol";  // 提案存储管理
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";  // 集成代币投票机制
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";  // 定义基于分数的法定人数
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";  // 时间锁控制，延迟执行操作

// `AdvancedGovernance` 合约继承自多个 OpenZeppelin 治理扩展模块
contract AdvancedGovernance is Governor, 
    GovernorSettings, 
    GovernorCountingSimple, 
    GovernorStorage, 
    GovernorVotes, 
    GovernorVotesQuorumFraction, 
    GovernorTimelockControl {

    // 构造函数，用于初始化治理合约，传入代币和时间锁控制器
    constructor(IVotes _token, TimelockController _timelock)
        Governor("AdvancedGovernance") // 设置治理合约的名称
        GovernorSettings(7200 /* 1天 */, 50400 /* 1周 */, 20e18) // 设置投票延迟、投票周期和提案门槛
        GovernorVotes(_token) // 提供用于治理的代币（IVotes）
        GovernorVotesQuorumFraction(4) // 设置法定人数为4%
        GovernorTimelockControl(_timelock) // 初始化时间锁控制，使用 TimelockController
    {}

    // 重写投票延迟函数
    // 投票延迟定义了提案创建后，投票开始之前的等待时间
    function votingDelay() 
        public 
        view 
        override(Governor, GovernorSettings) 
        returns (uint256) 
    {
        return super.votingDelay(); // 调用 GovernorSettings 中的函数
    }

    // 重写投票周期函数
    // 投票周期定义了投票开始后，投票持续的时间
    function votingPeriod() 
        public 
        view 
        override(Governor, GovernorSettings) 
        returns (uint256) 
    {
        return super.votingPeriod(); // 调用 GovernorSettings 中的函数
    }

    // 重写法定人数函数
    // 法定人数是提案通过所需的最小投票数
    function quorum(uint256 blockNumber) 
        public 
        view 
        override(Governor, GovernorVotesQuorumFraction) 
        returns (uint256) 
    {
        return super.quorum(blockNumber); // 调用 GovernorVotesQuorumFraction 中的函数
    }

    // 重写提案状态函数
    // 提案的状态可能是 Active（进行中）、Canceled（已取消）、Defeated（已失败）、Executed（已执行）等
    function state(uint256 proposalId) 
        public 
        view 
        override(Governor, GovernorTimelockControl) 
        returns (ProposalState) 
    {
        return super.state(proposalId); // 调用 GovernorTimelockControl 中的函数
    }

    // 重写提案是否需要排队的函数
    // 该函数在需要时间锁延迟执行操作时使用
    function proposalNeedsQueuing(uint256 proposalId) 
        public 
        view 
        override(Governor, GovernorTimelockControl) 
        returns (bool) 
    {
        return super.proposalNeedsQueuing(proposalId); // 调用 GovernorTimelockControl 中的函数
    }

    // 重写提案门槛函数
    // 提案门槛是创建提案所需的最小投票数
    function proposalThreshold() 
        public 
        view 
        override(Governor, GovernorSettings) 
        returns (uint256) 
    {
        return super.proposalThreshold(); // 调用 GovernorSettings 中的函数
    }

    // 内部函数，用于创建提案
    // 当创建提案时，会调用此函数
    function _propose(
        address[] memory targets, 
        uint256[] memory values, 
        bytes[] memory calldatas, 
        string memory description, 
        address proposer
    ) 
        internal 
        override(Governor, GovernorStorage) 
        returns (uint256) 
    {
        return super._propose(targets, values, calldatas, description, proposer); // 调用 GovernorStorage 中的函数
    }

    // 内部函数，用于排队提案的操作
    // 该函数将提案中的操作排队，等待执行并受到时间锁的控制
    function _queueOperations(
        uint256 proposalId, 
        address[] memory targets, 
        uint256[] memory values, 
        bytes[] memory calldatas, 
        bytes32 descriptionHash
    ) 
        internal 
        override(Governor, GovernorTimelockControl) 
        returns (uint48) 
    {
        return super._queueOperations(proposalId, targets, values, calldatas, descriptionHash); // 调用 GovernorTimelockControl 中的函数
    }

    // 内部函数，用于执行排队的操作
    // 该函数在提案的时间锁期过后执行排队的操作
    function _executeOperations(
        uint256 proposalId, 
        address[] memory targets, 
        uint256[] memory values, 
        bytes[] memory calldatas, 
        bytes32 descriptionHash
    ) 
        internal 
        override(Governor, GovernorTimelockControl) 
    {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash); // 调用 GovernorTimelockControl 中的函数
    }

    // 内部函数，用于取消提案
    // 如果提案在执行之前被取消，则调用此函数
    function _cancel(
        address[] memory targets, 
        uint256[] memory values, 
        bytes[] memory calldatas, 
        bytes32 descriptionHash
    ) 
        internal 
        override(Governor, GovernorTimelockControl) 
        returns (uint256) 
    {
        return super._cancel(targets, values, calldatas, descriptionHash); // 调用 GovernorTimelockControl 中的函数
    }

    // 内部函数，用于获取治理操作的执行者
    // 执行者是负责在排队期后执行提案操作的地址
    function _executor() 
        internal 
        view 
        override(Governor, GovernorTimelockControl) 
        returns (address) 
    {
        return super._executor(); // 调用 GovernorTimelockControl 中的函数
    }
}