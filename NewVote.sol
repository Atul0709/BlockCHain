// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Ballot{
    struct Voter{
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    
    struct Proposal{
        bytes32 name;
        uint voteCount;
    }
    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposal;
    constructor(bytes32[] memory proposalName){
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for(uint i = 0; i< proposalName.length ; i++){
            proposal.push(Proposal(
                {
                    name : proposalName[i],
                    voteCount : 0
                }
            ));
        }

    }
    function givenRightToVote(address voter) external{
        require(!voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1 ;
    }
    function delegate(address to )external{
        Voter storage sender = voters[msg.sender];
        require(sender.weight == 0,"You have no right to vote");

        while (voters[to].delegate != address (0)){
            to = voters[to].delegate;
            require(to !=msg.sender,"found loop");
        }
        Voter storage delegate_=voters[to];
        require(delegate_.weight >=1);
    }

}