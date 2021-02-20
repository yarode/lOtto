pragma solidity ^0.8.1;

import "hardhat/console.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract Otto {

  using SafeMath for uint;

  constructor() {
    address winningAddress;
    address[] participants;
  }

  struct Entry {
    uint amount;
    uint startDate;
  }

  mapping (address => Entry) entryByParticipant;
  mapping (address => uint) currentShareSize;

  function getShareSize(Entry tempEntry) private returns(uint) {
    return ((now() - prevEntry.startDate) * prevEntry.amount + currentShareSize[msg.sender]);
  }

  // function to become payable and take actual funds to stake
  function enter(uint amount) external {
    Entry memory newEntry;
    uint newShareShize = 1;
    // if user is depositing on top of an already existing entry
    if(currentShareSize[msg.sender]) {
      Entry prevEntry = entryByParticipant[msg.sender];
      newShareSize = (now() - prevEntry.startDate) * prevEntry.amount + currentShareSize[msg.sender];
      newEntry.amount = amount + prevEntry.amount;
      // staking logic here
    // if user has no share size yet
    } else {
      newEntry.amount = amount;
      currentShareSize[msg.sender] = newShareSize;
      participants.push[msg.sender];
      // staking logic here
    }
    newEntry.startDate = now();
    entryByParticipant[msg.sender] = newEntry;
  }

  // function to become payable and retrieve funds
  function exit(uint amount) external {
    
  }

  function deposit(uint amount) private payable {

  }

  function withdraw(uint amount) private payable {

  }

  function drawWinner() external onlyOwner {

  }

  // return proportional size multiplied by 10^5
  function getRelativeShareSize() public view returns(uint) {
    uint totalShareSize;
    for(uint i = 0; i < participants.length; i++) {
      totalShareSize = totalShareSize.add(getShareSize(entryByParticipant[participants[i]]));
    }
    return (getShareSize(entryByParticipant[participants[msg.sender]]) / totalShareSize * 10**5);
  }

}
