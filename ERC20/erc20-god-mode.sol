// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// *Requirements*

// God mode on an ERC20 token allows a special address to steal other people’s funds,
// create tokens, and destroy tokens. Implement the following functions:

// mintTokensToAddress(address recipient) => done ✅

// reduceTokensAtAddress(address target) => done ✅

// authoritativeTransferFrom(address from, address to) => done ✅

import "./erc20-simple.sol" ;

contract GodMode is ERC20 {

    address private god;

    constructor(address specialAddr){
        god = specialAddr;        
    }

    modifier onlyGod{
        require(msg.sender == god);
        _;
    }

    function mintTokensToAddress(address recipient, uint amount) public onlyGod{
        balanceOf[recipient] += amount;
        totalSupply += amount;
        emit Transfer(address(0), recipient, amount);
    }

    function reduceTokensAtAddress(address target, uint amount) public onlyGod{
        balanceOf[target] -= amount;
        totalSupply -= amount;
        emit Transfer(target, address(0), amount);
    }

    function authoritativeTransferFrom(address from, address to, uint amount) public onlyGod{
        require(balanceOf[from] >= amount,"Balance insufficient!");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }


}
