// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin TransparentUpgradeableProxy
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract FacadeProxyDeployer is Initializable, OwnableUpgradeable {
    address public proxy;
    address public logicContract;

    event ProxyDeployed(address proxy);

    // You can pass the logic contract and admin address via constructor
    function initialize(address _logicContract, address _admin) public initializer 
    {
        __Ownable_init(_admin);

        logicContract = _logicContract;

        TransparentUpgradeableProxy newProxy = new TransparentUpgradeableProxy(logicContract, _admin, "");

        proxy = address(newProxy);

        (bool success, ) = proxy.call(abi.encodeWithSignature("initialize()"));

        require(success, "Initialization failed");

        emit ProxyDeployed(proxy);
    }
}
