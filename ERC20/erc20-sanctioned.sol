// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

//REQUIREMENTS

//  the ability to prevent transfers to blacklisted addresses from occurring,
//  and they want addresses on a blacklist to not be able to transfer their funds
//  until they are removed from the blacklist.

// Hint: what is the appropriate data structure to store this blacklist? => A mapping ✅

// Hint: make sure only the government can control this list! => contructor declares government address ✅

import "./erc20-simple.sol";

contract Sanctioned is ERC20 {
    address private govAddr;

    mapping(address => bool) Blacklist;

    constructor(address governmentAddr) {
        govAddr = governmentAddr;
    }

    modifier onlyGov() {
        //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        require(msg.sender == govAddr, "Not Government Address!");
        _;
    }

    function addToBlacklist(address toBlacklist) public onlyGov {
        //0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 , 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
        require(Blacklist[toBlacklist] == false, "Already Blacklisted");
        Blacklist[toBlacklist] = true;
    }

    function removeFromBlacklist(address blacklistedAddr) public onlyGov {
        require(Blacklist[blacklistedAddr] == true, "Not Blacklisted");
        Blacklist[blacklistedAddr] = false;
    }

    function transfer(address recipient, uint256 amount) public override {
        require(Blacklist[msg.sender] == false, "Blacklisted Wallet");
        require(balanceOf[msg.sender] >= amount, "Balance insufficient!");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }
}
