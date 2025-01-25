import { deploy } from './Web3Library'

// Immediately Invoked Function Expression (IIFE)
// anonymous asynchronous function that gets executed as soon as the script is loaded
(async () => 
{
    const contractNames = 
    [
        'Bank', 
        'BankOpenZeppelin'
    ];
    
    for(const contractName of contractNames)
    {
        await deployContract(contractName);
    }
})()

async function deployContract(contractName: string) 
{
    try 
    {
        const result = await deploy(contractName, [])
        console.log(`address: ${result.address}`)
    }
    catch (error)
    {
        console.log(error.message)
    }
}