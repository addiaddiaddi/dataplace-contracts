// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/Marketplace.sol";
import "../src/USDC.sol";


contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(uint256(0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d));

        USDC usdc = new USDC();

        Marketplace marketplace = new Marketplace(address(usdc), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);

        usdc.approve(address(marketplace), 2**256 - 1);
        usdc.mint(address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8), 10000*10**18);
        usdc.mint(address(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC), 1000*10**18);
        usdc.mint(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1000*10**18);
        usdc.mint(address(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65), 1000*10**18);

        uint256 publicKey = 111;
        uint256 n = 1909;

        marketplace.createOrder("Fitbit Heartbeat", 10**18, publicKey, n);
        marketplace.createOrder("Fitbit Steps", 100*10**18, publicKey, n);
        marketplace.createOrder("Fitbit Stress", 1000*10**18, publicKey, n);


    }
}
