// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    ICryptoDevs CryptoDevsNFT;

    uint256 public constant tokensPerNFT = 10 * 10**18;
    uint256 public constant tokenPrice = 0.01 ether;
    uint256 public constant maxTotalSupply = 10000 * 10**18;
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(uint256 _amount) public payable {
        uint256 _requiredAmount = tokenPrice * _amount;
        require(msg.value >= _requiredAmount, "Ether sent is Incorrect");
        uint256 amountWithDecimal = _amount * 10**18;
        require(
            totalSupply() + amountWithDecimal <= maxTotalSupply,
            "Exceeds max total supply"
        );
        _mint(msg.sender, amountWithDecimal);
    }

    function claim() public {
        address sender = msg.sender;

        uint256 balance = CryptoDevsNFT.balanceOf(sender);
        require(balance > 0, "You dont own any Crypto dev BFT");

        uint256 amount = 0;

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed all your token");

        _mint(msg.sender, amount * tokensPerNFT);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw; contract balance empty");

        address _owner = owner();
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether!");
    }

    receive() external payable {}

    fallback() external payable {}
}
