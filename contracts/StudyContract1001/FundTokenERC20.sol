// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//FundMe
//1、让FundMe的参与者，基于mapping来领取相应数量的通证
//2、让FundMe的参与者，tranfer通证
//3、在使用完成后，需要burn通证

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

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