// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract lottery 
{
    address public manager;     //manager declaration done as address because it will store address of the manager
    address payable[] public participants; //payable participants for doing ether transaction.

    constructor()
    {
        manager=msg.sender; //Global variable returns (manager) address.
    }

    //To receive ethers from the participants (using payable)
    receive() external payable
    {
        require(msg.value==1 ether); //min 2 ethers should be transacted
        participants.push(payable(msg.sender));
    }

    function GetBalance() public view returns (uint)
    {
        require(msg.sender== manager); //balance visible only for manager
        return address(this).balance;
    }

    //To generate random variables of the participants
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    //getting index value from random to select the winner//
    function selectWinner() public
    {
        require(msg.sender== manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(GetBalance());
        participants=new address payable[](0);
    }
}

