// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// constructors won't work with proxies
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BankOpenZeppelinProxy is ReentrancyGuard, Initializable, OwnableUpgradeable
{
    event OnBalanceChanged(int indexed oldBalance, int indexed newBalance);
    event OnOwnerTransfered(address indexed oldOwner, address indexed newOwner);

    error NotOwner();
    error InsufficientBalance();

    int balance;
    
    function initialize() public initializer
    {
        __Ownable_init(msg.sender);
        balance = 0;
        emit OnBalanceChanged(0, balance);
    }

    function getBankAccountName() external pure returns (string memory)
    {
        return "BankOpenZeppelinProxy";
    }
    
    function getBalance() external view onlyOwner returns (int)
    {
        return balance;
    }

    function deposit(uint amount) public  onlyOwner
    {
        int intAmount = int(amount);
        balance += intAmount;
        emit OnBalanceChanged(balance - intAmount, balance);
    }

    function withdraw(uint amount) public onlyOwner
    {
        int intAmount = int(amount);
        if(intAmount > balance) revert InsufficientBalance();
        balance -= intAmount;
        emit OnBalanceChanged(balance + intAmount, balance);
    }
    
    // function transferFund(int amount) external onlyOwner nonReentrant
    // {
        // protected against reentrancy attacks
        // Checks-Effects-Interactions Pattern
        // require..
        // deduct amount from balance
        // extarnal call
    // }
}