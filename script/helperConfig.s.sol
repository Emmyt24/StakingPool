//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {MockV3Aggregator} from "../test/mock/mockV3Aggregator.sol";
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMAL = 8;
    int256 public constant ETH_PRICE = 2000e8;

    struct networkConfig {
        address priceFeed;
    }
    networkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getMainnetEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory mainnetConfig = networkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getSepoliaEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory sepoliaConfig = networkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }
    function getOrCreateAnvilEthConfig() public returns (networkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            ETH_PRICE
        );

        vm.stopBroadcast();
        networkConfig memory anvilConfig = networkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
