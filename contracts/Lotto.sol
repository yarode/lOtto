pragma solidity >=0.6.0 <0.8.0;

//import "./Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Lotto {

  using SafeMath for uint256;

  constructor() {
  }

  struct Entry {
    uint amount;
    uint startDate;
  }

  mapping (address => Entry) entryByParticipant;
  mapping (address => uint) shareSize;

  address[] participants;
  address winningAddress;

  function getCurrentShareSize(address participant) private view returns(uint) {
    return ((block.timestamp - entryByParticipant[participant].startDate) * entryByParticipant[participant].amount + shareSize[participant]);
  }

  // function to become payable and take actual funds to stake
  function enter(uint amount) external {
    // if user is depositing on top of an already existing entry
    if(shareSize[msg.sender] != 0) {
      shareSize[msg.sender] = getCurrentShareSize(msg.sender);
      entryByParticipant[msg.sender].amount = entryByParticipant[msg.sender].amount.add(amount);
    // if user has no share size yet
    } else {
      entryByParticipant[msg.sender].amount = amount;
      shareSize[msg.sender] = 1;
      participants.push(msg.sender);
    }
    entryByParticipant[msg.sender].startDate = block.timestamp;
    // staking logic here
  }

  function exit(uint amount) external {
    // Make sure user cannot withdraw more than staked amount and prevent withdrawing of 0
    require((amount <= entryByParticipant[msg.sender].amount) && (entryByParticipant[msg.sender].amount != 0), "cannot exit with balance 0 or amount 0");
    shareSize[msg.sender] = getCurrentShareSize(msg.sender);
    entryByParticipant[msg.sender].amount = entryByParticipant[msg.sender].amount.sub(amount);
    entryByParticipant[msg.sender].startDate = block.timestamp;
  }


  /*
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

  function getTotalStaked() public view returns(uint) {
    uint totalStaked;
    for(uint i = 0; i < participants.length; i++) {
      totalStaked = totalStaked.add(entryByParticipant[participants[i]].amount);
    }
    return totalStaked;
  }

  function getStartDate() public view returns(uint) {
    return entryByParticipant[msg.sender].startDate;
  }

  function getShareSize() public view returns(uint) {
    return ((block.timestamp - entryByParticipant[msg.sender].startDate) * entryByParticipant[msg.sender].amount + shareSize[msg.sender]);
  }

  function getTotalShareSize() public view returns(uint) {
    uint totalShareSize;
    for(uint i = 0; i < participants.length; i++) {
      totalShareSize = totalShareSize.add(getCurrentShareSize(participants[i]));
    }
    return totalShareSize;
  }

  // return proportional size multiplied by 10^5
  function getRelativeShareSize() public view returns(uint) {
    uint totalShareSize;
    for(uint i = 0; i < participants.length; i++) {
      totalShareSize = totalShareSize.add(getCurrentShareSize(participants[i]));
    }
    return (10**5 * getCurrentShareSize(msg.sender).div(totalShareSize));
  }

}
