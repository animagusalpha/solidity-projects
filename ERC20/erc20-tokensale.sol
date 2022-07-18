// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// Requirements
// Add a function where users can mint 1000 tokens if they pay 1 ether.

// IMPORTANT: your token should have 18 decimal places as is standard in ERC20 tokens

// IMPORTANT: your total supply should not exceed 1 million tokens. The sale should close after 1 million tokens have been minted

// IMPORTANT: you must have a function to withdraw the ethereum from the contract to your address

import "./erc20-simple.sol";

contract tokensale is ERC20 {
    function mintWithEth() public payable {
        require(msg.value == 1 ether, "tokensale requires 1 Ether (only)");
        require(totalSupply + 1000 <= 1000000, "Purchase exceeds max supply");

        balanceOf[msg.sender] += 1000;
        totalSupply += 1000;
    }

    function withdrawFromContract() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
