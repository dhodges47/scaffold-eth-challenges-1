pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }
    uint256 public constant tokensPerEth = 100;

  // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
          uint ethSent = msg.value;
          uint tokensToBuy = ethSent * tokensPerEth;
          yourToken.transfer(msg.sender, tokensToBuy);
          emit BuyTokens(msg.sender, msg.value, tokensToBuy);
    }
  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  // ToDo: create a sellTokens(uint256 _amount) function:

}
