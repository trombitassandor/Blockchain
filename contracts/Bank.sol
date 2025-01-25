// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Bank is ReentrancyGuard
{
    event OnBalanceChanged(int indexed oldBalance, int indexed newBalance);
    event OnOwnerTransfered(address indexed oldOwner, address indexed newOwner);

    error NotOwner();
    error InsufficientBalance();


    address owner;
    int balance;

    modifier isOwner()
    {
        //require(msg.sender == owner, "Message sender is not the owner!");
        if(msg.sender != owner) revert NotOwner();
        _;
    }

    constructor ()
    {
        owner = msg.sender;
        balance = 0;
        emit OnBalanceChanged(0, balance);
    }
    
    function getBalance() isOwner external view returns (int)
    {
        return balance;
    }

    function getOwner() external view returns (address)
    {
        return owner;
    }

    function deposit(uint amount) isOwner public 
    {
        int intAmount = int(amount);
        balance += intAmount;
        emit OnBalanceChanged(balance - intAmount, balance);
    }

    function withdraw(uint amount) isOwner public
    {
        int intAmount = int(amount);
        //require(intAmount <= balance, "Insufficient balance!");
        if(intAmount > balance) revert InsufficientBalance();
        balance -= intAmount;
        emit OnBalanceChanged(balance + intAmount, balance);
    }

    function transferOwnership(address newOwner) isOwner external 
    {
        require(newOwner != address(0), "Address can't be zero!");
        address oldOwner = owner;
        owner = newOwner; 
        emit OnOwnerTransfered(oldOwner, newOwner);
    }
    
    function transferFund(int amount) isOwner external nonReentrant
    {
        // protected against reentrancy attacks
        // Checks-Effects-Interactions Pattern
        // require..
        // deduct amount from balance
        // extarnal call
    }
}