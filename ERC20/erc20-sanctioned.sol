// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

//REQUIREMENTS

//  the ability to prevent transfers to blacklisted addresses from occurring,
//  and they want addresses on a blacklist to not be able to transfer their funds 
//  until they are removed from the blacklist.

// Hint: what is the appropriate data structure to store this blacklist? => A mapping 

// Hint: make sure only the government can control this list! => contructor declares government address


import "'/erc20-simple.sol";

contract Sanctioned is ERC20 {

    address private govAddr;

    mapping(address => bool) Balcklist;

    constructor(address governmentAddr){
        govAddr = governmentAddr;
    }

    modifier onlyGov{
        require( ,"")
    }

    function addToBlacklist(address toBlacklist) external {

    }


}