// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;
import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../contracts/Bank.sol";
import "hardhat/console.sol";

contract testSuite 
{
    Bank bank;
    address originalOwner;

    Bank otherBank;
    address otherOwner;

    function beforeAll() public 
    {
        bank = new Bank();
        originalOwner = msg.sender;

        otherBank = new Bank();
        otherOwner = address(0xA09BfF371d26c4D58eE9A9CcEbDbecFeccCf3Ee6);
    }

    function checkInitialState() public view
    {
        assert(address(bank) != address(0));
        assert(bank.getOwner() == originalOwner);
        assert(bank.getBalance() == 0);
    }

    function transferOwner() public 
    {
        otherBank.transferOwnership(otherOwner);
        assert(otherBank.getOwner() == otherOwner);
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

    function checkDeposit_NotOwner() public 
    {
        try otherBank.deposit(1)
        {
            assert(false);
        }
        catch
        {
            assert(true);
        }
    }

    function checkWithdraw_NotOwner() public 
    {
        try otherBank.withdraw(1)
        {
            assert(false);
        }
        catch
        {
            assert(true);
        }
    }
}
