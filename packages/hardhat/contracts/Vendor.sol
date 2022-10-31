pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event Withdraw(address owner, uint256 amountOfETH);
    event Transfer(address sender, address recipient, uint256 amountOfETH);
    event SellTokens(
        address seller,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    uint256 public constant tokensPerEth = 100;

    modifier CheckEthInContract(uint256 amt) {
        require(
            amt <= address(this).balance,
            "Not enough eth in contract to withdraw this amount"
        );
        _;
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        uint ethSent = msg.value;
        uint tokensToBuy = ethSent * tokensPerEth;
        yourToken.transfer(msg.sender, tokensToBuy);
        emit BuyTokens(msg.sender, msg.value, tokensToBuy);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner 
    {
       uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "Owner has not balance to withdraw");

        (bool sent,) = msg.sender.call{value: address(this).balance}("");
         require(sent, "Failed to send user balance back to the owner");
        emit Withdraw(msg.sender, ownerBalance);
    }

  
    function sellTokens(uint256 amount) public {
        require(amount > 0, "Specify the amount you want to sell");

        require(
            yourToken.allowance(msg.sender, address(this)) >= amount,
            "Token allowance too low"
        );
        uint256 payout = amount / tokensPerEth;

        require(
            address(this).balance >= payout,
            "not enough ETH in the contract, try later"
        );
        // should not send user eth before tokens get transferred

        (bool success, ) = msg.sender.call{value: payout}("");

        require(success, "FAILED");
        _safeTransferFrom(yourToken, msg.sender, address(this), amount);

        emit SellTokens(msg.sender, payout, amount);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}
