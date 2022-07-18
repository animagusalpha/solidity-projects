// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

//  give the users the ability to transfer their tokens to the contract and receive 0.5 ether for every 1000 tokens they transfer.

import "./erc20-tokensale.sol";

contract tokensale_V2 is tokensale {
    function redeemETHforToken(uint256 _amount) public {
        uint256 units = _amount / 1000;
        require(_amount % 1000 == 0, "should be in 1000's");
        require(
            allowance[msg.sender][address(this)] >= _amount,
            "To redeem: sign for allowance first"
        );
        require(
            address(this).balance >= (0.5 ether * units),
            "Insufficent funds in contract to reddem ETH"
        );

        transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(0.5 ether * units);
    }

    function mintWithEth() public payable override {
        require(msg.value == 1 ether, "tokensale requires 1 Ether (only)");
        require(
            totalSupply + 1000 <= 1000000 || balanceOf[address(this)] >= 1000,
            "Purchase exceeds max supply or Insufficent tokens in contract"
        );
        if (totalSupply + 1000 <= 1000000) {
            balanceOf[msg.sender] += 1000;
            totalSupply += 1000;
        } else {
            balanceOf[address(this)] -= 1000;
            balanceOf[msg.sender] += 1000;
        }
    }
}
