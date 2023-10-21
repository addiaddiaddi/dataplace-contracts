pragma solidity ^0.8.13;


import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract USDC is ERC20 {
    constructor() ERC20("USDC", "USDC") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}