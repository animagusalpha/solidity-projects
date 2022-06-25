// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.5;
pragma abicoder v2;

// * Wallet Requirements *

// Anyone should be able to deposit ether to the Wallet ✅

// The contract creator should be able to Input 
// (01) The addresses of the owners and ✅
// (02) The Number of approvals required for a transfer ✅
// in the constructor
// For example, input 3 addresses and set the approval limit to 2. 

// Anyone of the owners should be able to create a transfer request. ✅
// The creator of the transfer request will specify what amount ✅
// and to what address the transfer will be made.✅

// Owners should be able to approve transfer requests.✅

// When a transfer request has the required approvals, the transfer should be sent.✅

contract Wallet{

    address[] public owners;
    uint limit;

    struct transferRequest{
        address payable reciever;
        uint amount;
        uint id;
        bool sent;
        uint approvalCount;
    }
    
    transferRequest[] transferLog; 

    //double mapping required to track approvals
    mapping(address =>mapping(uint=>bool)) approvals;


    //restrict to only multisig owners
    modifier onlyOwners{
        bool owner =false;
        for(uint i = 0; i<owners.length;i++){
            if(msg.sender == owners[i]){
                owner = true;
            }
        }
        require(owner == true);
        _;
    }

    //declaring the owners of the wallet and the required limit for approval of transactions 
    constructor(address[] memory _owners,uint _limit){
        owners = _owners;
        limit =_limit;
    }

    //deposit ether to contract
    function deposit() public payable{
    }

    //creating the initial transfer request by the owners
    function createTransferRequest(address payable _reciever, uint _amount) public onlyOwners{
        transferLog.push(transferRequest(_reciever, _amount, transferLog.length,false,0));
    }

    //aprroving the pending requests by the owners 
    function approveTranfer(uint _id) public onlyOwners{
        require(approvals[msg.sender][_id] ==false);

        approvals[msg.sender][_id] =true;
        transferLog[_id].approvalCount++;

        if(transferLog[_id].approvalCount >= limit){
            transferLog[_id].reciever.transfer(transferLog[_id].amount);
            transferLog[_id].sent = true;
        }

    }
    
    //checking the transfer request log
    function getTranferRequest()public view returns(transferRequest[] memory){
        return transferLog;
    }
    //checking the contract balance
    function getContractBalance()public view returns(uint){
        return address(this).balance;
    }

}

//add events next
