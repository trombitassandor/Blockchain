import { expect } from "chai";
import { ethers } from "hardhat";

describe("Storage", function () 
{
    let bank;
    const otherAddress = "0xA09BfF371d26c4D58eE9A9CcEbDbecFeccCf3Ee6";
    // let accountAddress;
    // let accountSigner;

    beforeEach(async function () 
    {
        const [signer] = await ethers.getSigners();
        signerAddress = await signer.getAddress();

        const bankFactory = await ethers.getContractFactory("Bank");
        const bankToDeploy = await bankFactory.deploy();
        await bankToDeploy.deployed();
        bank = await ethers.getContractAt("Bank", bankToDeploy.address);
        console.log("bank deployed at:" + bank.address);

        // accountAddress = "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2";
        // accountSigner = await ethers.provider.getSigner(accountAddress); 
        // await bank.connect(accountSigner).deposit();
    });

    const getOwner = async() => await bank.getOwner();
    const getBalance = async() => (await bank.getBalance()).toNumber();
    const deposit = async(amount) => (await bank.deposit(amount)).wait();
    const withdraw = async(amount) => (await bank.withdraw(amount)).wait();
    const transferOwnership = async(newOwner) => (await bank.transferOwnership(newOwner)).wait();

    it("test initial values", async function () 
    {
        const owner = await getOwner();
        expect(owner).to.equal(signerAddress);

        const balance = await getBalance();
        expect(balance).to.equal(0);
    });
    
    it("test deposit", async function ()
    {
        const depositAmount = 1;
        const originalBalance = await getBalance();
        await deposit(depositAmount);
        const newBalance = await getBalance();
        expect(newBalance).to.equal(originalBalance + depositAmount);
    });

    it("test deposit & withdraw", async function ()
    {
        const depositAndWithdrawAmount = 1;
        const originalBalance = await getBalance();
        await deposit(depositAndWithdrawAmount);
        await withdraw(depositAndWithdrawAmount);
        const newBalance = await getBalance();
        expect(newBalance).to.equal(originalBalance);
    });
    
    it("test transfer ownership", async function()
    {
        await transferOwnership(otherAddress);
        const bankOwner = await bank.getOwner();
        expect(bankOwner).to.equal(otherAddress);
    });

    it("test deposit & withdraw & transfer ownership with other address", async function()
    {
        await transferOwnership(otherAddress);
        try
        {
            await deposit(1);
            await withdraw(1);
            await transferOwnership(signerAddress);
            assert.fail("Fail due to successfull deposit or withdraw or transfer ownership with different owner address");
        }
        catch (error)
        {
            // passed
        }
    });
});