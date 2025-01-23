import { expect } from "chai";
import { ethers } from "hardhat";

describe("Storage", function () 
{
    let bank;
    // let accountAddress;
    // let accountSigner;

    beforeEach(async function () 
    {
        const bankFactory = await ethers.getContractFactory("Bank");
        const bankToDeploy = await bankFactory.deploy();
        await bankToDeploy.deployed();
        bank = await ethers.getContractAt("Bank", bankToDeploy.address);

        // accountAddress = "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2";
        // accountSigner = await ethers.provider.getSigner(accountAddress); 
        // await bank.connect(accountSigner).deposit();
    });

    it("test initial value", async function () 
    {
        console.log("bank deployed at:" + bank.address);
        expect((await bank.getBalance()).toNumber()).to.equal(0);
    });
    
    it("test deposit", async function ()
    {
        const originalBalance = (await bank.getBalance()).toNumber();

        const depositAmount = 1;
        const depositTx = await bank.deposit(depositAmount);
        await depositTx.wait();

        const newBalance = (await bank.getBalance()).toNumber();

        expect(newBalance).to.equal(originalBalance + depositAmount);
    });

    it("test deposit & withdraw", async function ()
    {
        const originalBalance = (await bank.getBalance()).toNumber();

        const depositAndWithdrawAmount = 1;

        const depositTx = await bank.deposit(depositAndWithdrawAmount);
        await depositTx.wait();

        const withdrawTx = await bank.withdraw(depositAndWithdrawAmount);
        await withdrawTx.wait();

        const newBalance = (await bank.getBalance()).toNumber();

        expect(newBalance).to.equal(originalBalance);
    });
});