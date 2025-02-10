// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallerContract {
    address payable targetContractAddress;

    constructor(address payable  _targetContractAddress){
        targetContractAddress = _targetContractAddress;
    }

    // Function to call deposit function on TargetContract and handle the return value
    function callDeposit(address _to, uint256 _amount) external payable {
        // Encode the function signature and parameters
        bytes memory data = abi.encodeWithSignature("deposit(address,uint256)", _to, _amount);
        
        // Call the target contract using call, sending ether and gas
        (bool success, bytes memory returnData) = targetContractAddress.call{value: msg.value}(data);

        // Ensure the call was successful
        require(success, "Call failed");

        // If the target function has a return value, decode it
        bool result = abi.decode(returnData, (bool));

        // Do something with the result
        require(result, "Deposit failed");
    }
}