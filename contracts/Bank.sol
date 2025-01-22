// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Bank
{
    event OnBalanceChanged(int indexed oldBalance, int indexed newBalance);

    address owner;
    int balance;

    modifier isOwner()
    {
        require(msg.sender == owner, "Message sender is not the owner!");
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
        require(intAmount <= balance, "Insufficient balance!");
        balance -= intAmount;
        emit OnBalanceChanged(balance + intAmount, balance);
    }
}