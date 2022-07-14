// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// *Requirements*
// Your ERC20 token does not need to be as featured. But it should support:

// creation of tokens => done ✅ - available for only owner
// transferring of tokens => done ✅
// tracking the total supply => done ✅
// approving other addresses to transfer on behalf of other addresses => done ✅

contract ERC20 {
    // for contract
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    //metadata
    string public name = "Coin";
    string public symbol = "COIN";
    uint256 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function mint(uint256 amount) public onlyOwner {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function getBalanceOf(address walletAddr) public view returns (uint256) {
        return balanceOf[walletAddr];
    }

    function burn(uint256 amount) public onlyOwner {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function transfer(address recipient, uint256 amount) public virtual {
        //transfering from own account
        require(balanceOf[msg.sender] >= amount, "Balance insufficient!");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public {
        //allowing other account to spend token on your behalf
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public {
        //transfering from other account after approval
        require(
            allowance[sender][msg.sender] >= amount,
            "Allowance insufficient!"
        );
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
    }
}
