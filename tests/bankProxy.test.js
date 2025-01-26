import { ethers, upgrades } from "hardhat";
import { expect } from "chai";

describe("Upgradeable Proxy Contract Tests", function () 
{
    let bankName = "BankProxy";
    let bankOpenZeppelinName = "BankOpenZeppelinProxy";
    let owner;
    let proxy;
    let bank;
    let bankOpenZeppelin;

    beforeEach(async function () 
    {
        [owner] = await ethers.getSigners();

        bank = await ethers.getContractFactory(bankName);
        bankOpenZeppelin = await ethers.getContractFactory(bankOpenZeppelinName);

        // hardhat specific that is not available in Remix - deploy and test in remix env instead
        proxy = await upgrades.deployProxy(bank, [], { initializer: 'initialize' });
        await proxy.deployed();

        console.log("BankProxy deployed at:" + proxy.address);
    });

    it("should deploy and interact with Bank", async function ()
    {
        const bankInstance = await ethers.getContractAt(bankName, proxy.address);
        const bankAccountName = getBankAccountName(bankName, owner.address);

        expect(await bankInstance.getBankAccountName()).to.equal(bankAccountName);
    });

    it("should upgrade to BankOpenZeppelin and interact with new functionality", async function () 
    {
        await upgrades.upgradeProxy(proxy.address, bankOpenZeppelin);

        console.log("upgraded to BankOpenZeppeling at:" + proxy.address);

        const bankInstance = await ethers.getContractAt(bankOpenZeppelinName, proxy.address);
        const bankAccountName = getBankAccountName(bankOpenZeppelinName, owner.address);

        expect(await bankInstance.getBankAccountName()).to.equal(bankAccountName);
    });

    function getBankAccountName(bankName, ownerAddress)
    {
        const bankAccountName = ethers.utils.solidityPack(
            ["string", "string", "address"],
            [bankName, "_", ownerAddress]);
        
        return bankAccountName;
    }
});
