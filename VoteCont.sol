// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Vote{
    struct BallotVoter{
        int delegateWeightt;
        bool voterSpent;
        address delegateTo;
        uint voteIndex;
    }
    struct Proposal{
        bytes32 proposalName;
        uint voteCount;
    }
    address public chairman;
    mapping(address => BallotVoter) public BallotVoter;

    Proposal[] public;
    function Ballot(bytes32[] propsalNames){
        chairman = msg.sender;
    }

}