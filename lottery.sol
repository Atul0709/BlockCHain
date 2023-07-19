// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// The Lottery contract
contract Lottery {
    // Address of the manager who deploys the contract
    address public manager;

    // Array to store the addresses of the players who entered the lottery
    address payable[] public players;

    // Constructor to set the manager as the contract deployer
    constructor() {
        manager = msg.sender;
    }

    // Function to check if the sender has already entered the lottery
    function alreadyEntered() view private returns(bool) {
        // Iterate through the players array and check if the sender's address matches any of the stored addresses
        for (uint i = 0; i < players.length; i++) {
            if (players[i] == msg.sender)
                return true;
        }
        // Return false if the sender's address is not found in the players array
        return false;
    }

    // Function to enter the lottery by sending at least 2 ether
    function enter() payable public {
        // The manager cannot enter the lottery
        require(msg.sender != manager, "Manager cannot enter");

        // Check if the player has not already entered
        require(alreadyEntered() == false, "Player already entered");

        // Minimum amount of 2 ether must be paid to enter
        require(msg.value >= 2 ether, "Minimum amount must be paid");

        // Add the sender's address to the players array
        players.push(payable(msg.sender));

        // Add a requirement that at least 5 players should be added before proceeding
        require(players.length >= 5, "At least 5 players must be added");
    }

    // Function to generate a random number based on previous random number, block number, and player addresses
    function random() private view returns (uint) {
        return uint(sha256(abi.encodePacked(block.prevrandao, block.number, players)));
    }

    // Function for the manager to pick a winner randomly
    function pickWinner() public {
        // Only the manager can pick the winner
        require(msg.sender == manager, "Only manager can pick the winner");

        // Generate a random index within the range of the players array
        uint index = random() % players.length;

        // Get the contract address
        address contractAddress = address(this);

        // Transfer the contract's balance to the winner
        players[index].transfer(contractAddress.balance);

        // Reset the players array for the next round of the lottery
        players = new address payable[](0);
    }

    // Function to get the list of players in the lottery
    function getPlayers() view public returns(address payable[] memory) {
        return players;
    }
}
