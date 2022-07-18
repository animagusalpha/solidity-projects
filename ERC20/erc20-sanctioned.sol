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
        require(msg.sender == govAddr, "Not Government Address!");
        _;
    }

    function addToBlacklist(address toBlacklist) public onlyGov {
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

    function approve(address spender, uint256 amount) public override {
        require(Blacklist[msg.sender] == false, "Blacklisted Wallet");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override {
        require(Blacklist[sender] == false, "Blacklisted Wallet");

        require(
            allowance[sender][msg.sender] >= amount,
            "Allowance insufficient!"
        );
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
    }
}
