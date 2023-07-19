// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;  // Specifies the version of the Solidity compiler this contract is compatible with.

contract TrustFund {  // Defines a contract named "TrustFund".
    struct Campaign {  // Defines a structure named "Campaign" to represent a crowdfunding campaign.
        address owner;  // Address of the campaign owner.
        string title;  // Title of the campaign.
        string description;  // Description of the campaign.
        uint256 target;  // Target amount to be collected in the campaign.
        uint256 deadline;  // Deadline of the campaign.
        uint256 amountCollected;  // Amount collected in the campaign so far.
        string image;  // Image associated with the campaign.
        address[] donators;  // Addresses of the campaign's donators.
        uint256[] donations;  // Donation amounts corresponding to each donator.
    }

    mapping(uint256 => Campaign) public campaigns;  // Maps campaign IDs to Campaign structures.

    uint256 public numberofCampaigns = 0;  // Total number of campaigns created.

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {  // Creates a new campaign and returns its ID.
        Campaign storage campaign = campaigns[numberofCampaigns];  // Retrieves the storage reference to the campaign.

        require(
            campaign.deadline < block.timestamp,  // Checks if the campaign deadline is in the future.
            "The deadline should be a date in the future"
        );

        campaign.owner = _owner;  // Sets the campaign owner.
        campaign.title = _title;  // Sets the campaign title.
        campaign.description = _description;  // Sets the campaign description.
        campaign.target = _target;  // Sets the campaign target amount.
        campaign.deadline = _deadline;  // Sets the campaign deadline.
        campaign.amountCollected = 0;  // Initializes the amount collected to zero.
        campaign.image = _image;  // Sets the campaign image.

        numberofCampaigns++;  // Increments the total number of campaigns.

        return numberofCampaigns - 1;  // Returns the ID of the newly created campaign.
    }

    function donateToCampaign(uint256 _id) public payable {  // Allows a user to donate to a campaign.
        uint256 amount = msg.value;  // Retrieves the donated amount from the transaction.
        Campaign storage campaign = campaigns[_id];  // Retrieves the storage reference to the campaign.

        campaign.donators.push(msg.sender);  // Adds the donor's address to the campaign's list of donators.
        campaign.donations.push(amount);  // Adds the donated amount to the campaign's list of donations.

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");  // Sends the donated amount to the campaign owner.

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;  // Updates the amount collected in the campaign.
        }
    }

    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {  // Retrieves the list of donators and their corresponding donations for a given campaign.
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {  // Retrieves all the campaigns created.
        Campaign[] memory allCampaigns = new Campaign[](numberofCampaigns);  // Initializes an array to store all the campaigns.

        for (uint i = 0; i < numberofCampaigns; i++) {  // Iterates over each campaign and stores it in the array.
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }
        return allCampaigns;  // Returns the array containing all the campaigns.
    }
}
