// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;
import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../contracts/Bank.sol";
import "hardhat/console.sol";

contract testSuite 
{
    Bank bank;

    function beforeAll() public 
    {
        bank = new Bank();
    }

    function checkInitialState() public view
    {
        assert(address(bank) != address(0));
        assert(bank.getOwner() == msg.sender);
        assert(bank.getBalance() == 0);
    }

    function checkDeposit() public
    {
        int balance = bank.getBalance();
        uint depositAmount = 1;
        int balanceAfterDeposit = balance + int(depositAmount);
        bank.deposit(depositAmount);
        assert(bank.getBalance() == balanceAfterDeposit);
    }

    function checkWithdrawal() public
    {
        int balance = bank.getBalance();
        uint withdrawalAmount = 1;
        int balanceAfterWithdrawal = balance - int(withdrawalAmount);
        bank.withdraw(withdrawalAmount);
        assert(bank.getBalance() == balanceAfterWithdrawal);
    }

    function checkDepositDifferentOwner() public 
    {
        
    }
}
    