// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract BrokenSea {
    struct Bid {
        address erc721Address;
        uint256 nftID;
        address erc20Address;
        uint256 amount;
    }
    mapping(address => Bid) bids;
 
    function createBid(
        ERC721 erc721Token,
        uint256 erc721TokenId,
        ERC20 erc20Token,
        uint256 amount
    )
        external
    {
        Bid memory bid = Bid(address(erc721Token),erc721TokenId,address(erc20Token),amount);
        bids[msg.sender]= bid;
    }

    function acceptBid(
        address bidder,
        ERC721 erc721Token,
        uint erc721TokenId,
        ERC721 erc20Token,
        uint256 amount
    )
        external
    {
        
        uint256 bidAmount = bids[bidder].amount;
     
        require(bidAmount != 0, "BrokenSea::fillBid/BID_PRICE_ZERO");
       
        require(bidAmount >= amount, "BrokenSea::fillBid/BID_TOO_LOW");

        delete bids[bidder];

        erc721Token.transferFrom(msg.sender,bidder,erc721TokenId);

        erc20Token.transferFrom(bidder, msg.sender, amount);

    }

}