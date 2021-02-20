pragma solidity >=0.6.0 <0.8.0;

//import "./Ownable.sol";
import "./SafeMath.sol";

contract Otto {

  using SafeMath for uint256;

  constructor() {
  }

  struct Entry {
    uint amount;
    uint startDate;
  }

  mapping (address => Entry) entryByParticipant;
  mapping (address => uint) currentShareSize;

  address[] participants;
  address winningAddress;

  function getShareSize(Entry memory tempEntry) private view returns(uint) {
    return ((block.timestamp - tempEntry.startDate) * tempEntry.amount + currentShareSize[msg.sender]);
  }

  // function to become payable and take actual funds to stake
  function enter(uint amount) external {
    Entry memory newEntry;
    uint newShareSize;
    // if user is depositing on top of an already existing entry
    if(currentShareSize[msg.sender] != 0) {
      Entry memory prevEntry = entryByParticipant[msg.sender];
      newShareSize = (block.timestamp - prevEntry.startDate) * prevEntry.amount + currentShareSize[msg.sender];
      newEntry.amount = amount + prevEntry.amount;
      // staking logic here
    // if user has no share size yet
    } else {
      newEntry.amount = amount;
      currentShareSize[msg.sender] = 1;
      participants.push(msg.sender);
      // staking logic here
    }
    newEntry.startDate = block.timestamp;
    entryByParticipant[msg.sender] = newEntry;
  }

  /* function to become payable and retrieve funds
  function exit(uint amount) external {

  }

  function deposit(uint amount) private payable {

  }

  function withdraw(uint amount) private payable {

  }

  function drawWinner() external onlyOwner {

  }
  */

  function getStakedAmount() public view returns(uint) {
    return entryByParticipant[msg.sender].amount;
  }

  function getStartDate() public view returns(uint) {
    return entryByParticipant[msg.sender].startDate;
  }

  // return proportional size multiplied by 10^5
  function getRelativeShareSize() public view returns(uint) {
    uint totalShareSize;
    for(uint i = 0; i < participants.length; i++) {
      totalShareSize = totalShareSize.add(getShareSize(entryByParticipant[participants[i]]));
    }
    return ((10**5 * getShareSize(entryByParticipant[msg.sender])).div(totalShareSize));
  }

}
