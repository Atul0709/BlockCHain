// SPDX-License-Identifier: MIT
// This line specifies the license under which the contract is distributed.

pragma solidity ^0.8.0;

// This line indicates the minimum version of Solidity required to compile the contract.

contract Trustfund {
    // This is the main contract named "Trustfund".

    struct Request {
        // This defines a struct named "Request" to hold information about a request.
        string description; // Description of the request.
        uint256 value; // Value (amount) of the request.
        address payable recipient; // Address of the recipient (who will receive the request amount).
        bool complete; // Flag indicating if the request is completed or not.
        uint256 approvalCount; // Count of approvals for the request.
        mapping(address => bool) approvals; // Mapping to track approvals from specific addresses.
    }

    Request[] public requests; // Array to store all the requests.

    address public manager; // Address of the manager/creator of the contract.
    uint256 public minimumContribution; // Minimum contribution required to become an approver.
    string campaign_title; // Title of the campaign.
    string campaign_description; // Description of the campaign.
    uint256 campaign_target; // Target amount to be raised for the campaign.
    string campaign_image_url; // URL of the campaign image.
    bool public campaignActiveStatus = true; // Flag to indicate if the campaign is active or not.

    mapping(address => bool) public approvers; // Mapping to track approvers and their status.
    uint256 public approversCount; // Count of total approvers.

    modifier restricited() {
        // A custom modifier to restrict access to certain functions.
        require(
            msg.sender == manager,
            "Only the contract manager can call this."
        );
        _; // This underscore means to execute the rest of the code of the modified function.
    }

    modifier activeCampaign() {
        // A custom modifier to ensure that the campaign is active before allowing certain functions.
        require(campaignActiveStatus == true, "The campaign is not active.");
        _; // Execute the rest of the code of the modified function.
    }

    constructor(
        uint256 minimum,
        address creator,
        string memory title,
        string memory description,
        uint256 target,
        string memory url
    ) {
        // Constructor function to initialize contract variables.
        manager = creator;
        minimumContribution = minimum;
        campaign_title = title;
        campaign_description = description;
        campaign_target = target;
        campaign_image_url = url;
    }

    function createRequest(
        string memory description,
        uint256 value,
        address payable recipient
    ) public restricited activeCampaign {
        // Function to create a new request.
        // Only the manager can call this function, and it should be during an active campaign.
        Request storage newRequest = requests.push();
        newRequest.description = description;
        newRequest.value = value;
        newRequest.recipient = recipient;
    }

    function approveRequest(uint256 index) public activeCampaign {
        // Function for approvers to approve a specific request.
        // Should be called during an active campaign.
        Request storage request = requests[index];

        require(approvers[msg.sender], "You are not an approved contributor.");
        require(
            !request.approvals[msg.sender],
            "You have already approved this request."
        );

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint256 index) public restricited activeCampaign {
        // Function to finalize a request once enough approvals are received.
        // Only the manager can call this function, and it should be during an active campaign.
        Request storage request = requests[index];

        require(
            request.approvalCount > (approversCount / 2),
            "Insufficient approvals."
        );
        require(!request.complete, "Request is already completed.");

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function switchCampaignActiveStatus() public restricited {
        // Function for the manager to switch the campaign's active status.
        // Only the manager can call this function.
        if (campaignActiveStatus) {
            campaignActiveStatus = false;
        } else {
            campaignActiveStatus = true;
        }
    }

    function modifyTarget(uint256 newTarget) public restricited activeCampaign {
        // Function for the manager to modify the campaign target amount.
        // Only the manager can call this function, and it should be during an active campaign.
        require(
            newTarget > address(this).balance,
            "New target must be greater than the current balance."
        );
        campaign_target = newTarget;
    }

    function conttribute() public payable activeCampaign {
        // Function for contributors to contribute to the campaign.
        // Should be called during an active campaign.
        if ((msg.value >= minimumContribution) && (!approvers[msg.sender])) {
            approvers[msg.sender] = true;
            approversCount++;
        }
    }

    function pool() public view returns (uint256) {
        // Function to get the current balance of the contract (the pool).
        return address(this).balance;
    }

    function getapprovedSpecificRequest(uint256 index)
        public
        view
        returns (bool)
    {
        // Function to check if a specific request is approved by the caller.
        return requests[index].approvals[msg.sender];
    }

    function getSummary()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            address,
            string memory,
            string memory,
            string memory,
            uint256,
            bool
        )
    {
        // Function to get a summary of the contract's variables.
        return (
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager,
            campaign_title,
            campaign_description,
            campaign_image_url,
            campaign_target,
            campaignActiveStatus
        );
    }
}
