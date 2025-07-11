// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract VotingSystem {
    error Voting__OnlyOwnerCanAdd();
    error Voting__AlreadyVoted();
    error Voting__VotingNotStarted();
    error Voting__IdAlreadyTaken();
    enum VotingState {
        START,
        STOP
    }

    address private owner = msg.sender;
    address[] private candidates;
    address[] private voters;
    mapping(uint256 => Voters) public votersId;
    VotingState private s_votingState;
    event voted(address indexed _voter);
    event candidateAdded(address indexed addedCandidate, uint256 indexed ID);
    constructor() {
        s_votingState = VotingState.STOP;
    }

    struct Voters {
        address candidate;
        uint256 votes;
    }

    uint256 public voteCast = 0;
    function addCandidate(address _candidate, uint256 id) public OnlyOwner {
        if (votersId[id].candidate == address(0)) {
            revert Voting__IdAlreadyTaken();
        }
        candidates.push(_candidate);
        votersId[id] = Voters(_candidate, 0);
        emit candidateAdded(_candidate, id);
        s_votingState = VotingState.START;
    }

    function vote(uint256 id) public votingCheck {
        if (s_votingState != VotingState.START) {
            revert Voting__VotingNotStarted();
        }
        votersId[id].votes += 1;
        emit voted(msg.sender);
    }
    function declareWinner()
        public
        view
        returns (address winner, uint256 votes)
    {
        uint256 highestVotes = 0;
        for (uint i = 0; i < voteCast; i++) {
            if (votersId[i].votes > highestVotes) {
                highestVotes = votersId[i].votes;
                winner = votersId[i].candidate;
            }
        }
        return (winner, highestVotes);
    }
    modifier votingCheck() {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i] == msg.sender) {
                revert Voting__AlreadyVoted();
            }
        }
        voters.push(msg.sender);
        voteCast += 1;
        _;
    }

    modifier OnlyOwner() {
        if (msg.sender != owner) {
            revert Voting__OnlyOwnerCanAdd();
        }
        _;
    }
}
