//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {StakingPool} from "../src/StakingPool.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./helperConfig.s.sol";

contract StakingPoolScript is Script {
    // HelperConfig helperConfig = new HelperConfig();
    // helperConfig.activeNetworkConfig();
    StakingPool public stakingPool;

    function run() external returns (StakingPool) {
        vm.startBroadcast();
        stakingPool = new StakingPool();
        vm.stopBroadcast();
        return stakingPool;
    }
}
