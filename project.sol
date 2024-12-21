// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScienceExperimentChallenge {
    struct Idea {
        uint id;
        string description;
        address submitter;
        uint voteCount;
    }

    mapping(uint => Idea) public ideas;
    mapping(address => bool) public hasVoted;
    uint public ideasCount;
    address public owner;

    event IdeaSubmitted(uint id, string description, address submitter);
    event Voted(uint ideaId, address voter);

    constructor() {
        owner = msg.sender;
    }

    function submitIdea(string memory _description) public {
        ideasCount++;
        ideas[ideasCount] = Idea(ideasCount, _description, msg.sender, 0);
        emit IdeaSubmitted(ideasCount, _description, msg.sender);
    }

    function vote(uint _ideaId) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_ideaId > 0 && _ideaId <= ideasCount, "Invalid idea ID.");

        hasVoted[msg.sender] = true;
        ideas[_ideaId].voteCount++;
        emit Voted(_ideaId, msg.sender);
    }

    function getIdea(uint _ideaId) public view returns (Idea memory) {
        require(_ideaId > 0 && _ideaId <= ideasCount, "Invalid idea ID.");
        return ideas[_ideaId];
    }

    function getWinningIdea() public view returns (uint winningIdeaId) {
        uint winningVoteCount = 0;
        for (uint i = 1; i <= ideasCount; i++) {
            if (ideas[i].voteCount > winningVoteCount) {
                winningVoteCount = ideas[i].voteCount;
                winningIdeaId = i;
            }
        }
    }
}