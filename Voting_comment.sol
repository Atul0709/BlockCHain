/*** The Address Book

The Chairperson:    0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

Proposal names:     Alice, Betty, Cecilia, Dana
Proposal names:     Alice, Betty, Cecilia, Dana
(name, bytes32-encoded name, account)

Alice:              0x416c696365000000000000000000000000000000000000000000000000000000  0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

Betty:              0x4265747479000000000000000000000000000000000000000000000000000000  0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

Cecilia:            0x436563696c696100000000000000000000000000000000000000000000000000  0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

Dana:               0x44616e6100000000000000000000000000000000000000000000000000000000  0x617F2E2fD72FD9D5503197092aC168c91465E7f2

Contract input argument:
["0x416c696365000000000000000000000000000000000000000000000000000000","0x4265747479000000000000000000000000000000000000000000000000000000","0x436563696c696100000000000000000000000000000000000000000000000000","0x44616e6100000000000000000000000000000000000000000000000000000000"]
***/


// SPDX-License-Identifier: GPL-3.0
// Specifies the license under which the code is released. In this case, it is released under the GNU General Public License version 3.0.

pragma solidity 0.8.20;
// Specifies the Solidity compiler version to be used, in this case, version 0.8.20.

contract Ballot {
    // Defines the Ballot contract.

    struct Voter {
        // Represents the structure for a voter.
        uint weight; // Weight of the voter (used for voting power).
        bool voted; // Indicates if the voter has already voted.
        address delegate; // Address of the delegate to whom the voter has delegated their voting right.
        uint vote; // Represents the index of the proposal the voter has voted for.
    }

    struct Proposal {
        // Represents the structure for a proposal.
        bytes32 name; // Name of the proposal.
        uint voteCount; // Number of votes received by the proposal.
    }

    address public chairperson; // Address of the chairperson who creates the ballot.

    mapping(address => Voter) public voters; // Mapping of addresses to Voter struct.

    Proposal[] public proposals; // Array of Proposal structs representing the available proposals.

    constructor(bytes32[] memory proposalNames) {
        // Constructor function for the Ballot contract.

        chairperson = msg.sender; // Sets the chairperson as the contract creator.
        voters[chairperson].weight = 1; // Assigns a weight of 1 to the chairperson.

        for (uint i = 0; i < proposalNames.length; i++) {
            // Iterates over the proposalNames array.

            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
            // Adds a new proposal with the provided name and initializes the vote count to 0.
        }
    }

    function giveRightToVote(address voter) external {
        // Grants the right to vote to a specific address.

        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        // Verifies that the caller is the chairperson.

        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        // Verifies that the voter has not already voted.

        require(voters[voter].weight == 0);
        // Verifies that the voter has no voting weight assigned.

        voters[voter].weight = 1;
        // Assigns a voting weight of 1 to the voter.
    }

    function delegate(address to) external {
        // Allows a voter to delegate their voting right to another address.

        Voter storage sender = voters[msg.sender];
        // Retrieves the voter struct for the caller.

        require(!sender.voted, "You already voted.");
        // Verifies that the caller has not already voted.

        require(to != msg.sender, "Self-delegation is disallowed.");
        // Verifies that the caller is not trying to delegate their vote to themselves.

        while (voters[to].delegate != address(0)) {
            // Loops as long as the delegate of the chosen address is not empty (already delegated).

            to = voters[to].delegate;
            // Updates the delegate address to the next delegate in the chain.

            require(to != msg.sender, "Found loop in delegation.");
            // Verifies that there is no loop in the delegation chain.
        }

        Voter storage delegate_ = voters[to];
        // Retrieves the voter struct for the final delegate address.

        sender.voted = true;
        // Marks the caller as having voted.

        sender.delegate = to;
        // Sets the delegate address for the caller.

        if (delegate_.voted) {
            // Checks if the delegate has already voted.

            proposals[delegate_.vote].voteCount += sender.weight;
            // Adds the weight of the caller's vote to the vote count of the delegate's chosen proposal.
        } else {
            delegate_.weight += sender.weight;
            // Adds the weight of the caller's vote to the delegate's voting weight.
        }
    }

    function vote(uint proposal) external {
        // Allows a voter to cast a vote for a specific proposal.

        Voter storage sender = voters[msg.sender];
        // Retrieves the voter struct for the caller.

        require(sender.weight != 0, "Has no right to vote");
        // Verifies that the voter has voting rights.

        require(!sender.voted, "Already voted.");
        // Verifies that the voter has not already voted.

        sender.voted = true;
        // Marks the voter as having voted.

        sender.vote = proposal;
        // Records the index of the proposal the voter has voted for.

        proposals[proposal].voteCount += sender.weight;
        // Increments the vote count for the chosen proposal by the voter's weight.
    }

    function winningProposal() public view
            returns (uint winningProposal_)
    {
        // Determines the winning proposal based on the vote counts.

        uint winningVoteCount = 0;
        // Initializes the winning vote count to 0.

        for (uint p = 0; p < proposals.length; p++) {
            // Iterates over the proposals.

            if (proposals[p].voteCount > winningVoteCount) {
                // Checks if the vote count of the current proposal is higher than the current winning vote count.

                winningVoteCount = proposals[p].voteCount;
                // Updates the winning vote count.

                winningProposal_ = p;
                // Updates the winning proposal index.
            }
        }
    }

    function winnerName() external view
            returns (bytes32 winnerName_)
    {   
        winnerName_ = proposals[winningProposal()].name;
        // Uses the winning proposal index to retrieve the corresponding proposal's name.
    }
}
