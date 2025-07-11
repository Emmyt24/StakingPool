//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Script} from "forge-std/Script.sol";
import {VotingSystem} from "../src/votingSystem.sol";

contract VotinfTest is Script {
    VotingSystem votingSystem;
    function run() external returns (VotingSystem) {
        vm.startBroadcast();
        votingSystem = new VotingSystem();
        vm.stopBroadcast();
        return votingSystem;
    }
}
