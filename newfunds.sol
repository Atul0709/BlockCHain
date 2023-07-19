// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Trustfund {
    address public manager;
    uint256 public minimumContribution;
    string campaign_title;
    string campaign_description;
    uint256 campaign_target;
    string campaign_image_url;
    bool public campaignActiveStatus = true;

    modifier restricited() {
        require(msg.sender == manager);
        _;
    }

    modifier activeCampaign() {
        require(campaignActiveStatus == true);
        _;
    }

    constructor(
        uint256 minimum,
        address creator,
        string memory title,
        string memory description,
        uint256 target,
        string memory url
    ) {
        manager = creator;
        minimumContribution = minimum;
        campaign_title = title;
        campaign_description = description;
        campaign_target = target;
        campaign_image_url = url;
    }

    function switchCampaignActiveStatus() public restricited {
        campaignActiveStatus = !campaignActiveStatus;
    }

    function modifyTarget(uint256 newTarget) public restricited activeCampaign {
        require(newTarget > address(this).balance);
        campaign_target = newTarget;
    }

    function contribute() public payable activeCampaign {
        // Implementation for contributing to the campaign
    }

    function pool() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public restricited {
        require(!campaignActiveStatus); // Only allow withdrawal when the campaign is not active
        require(address(this).balance >= campaign_target); // Ensure the target amount is reached

        // Transfer the collected funds to the manager
        payable(manager).transfer(address(this).balance);
    }
}
