import { deploy } from './../Web3Library'

(async () => 
{
    try
    {
        const result = await deploy('Bank', [])
        console.log(`address: ${result.address}`)
    } 
    catch (e)
    {
        console.log(e.message)
    }
})()