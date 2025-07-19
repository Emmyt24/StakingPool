//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {StakingPool} from "../src/StakingPool.sol";
import {StakingPoolScript} from "../script/StakingPool.s.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {HelperConfig} from "../script/helperConfig.s.sol";

contract StakingPoolTest is Test {
    StakingPool stakingPool;

    event userHasStaked(
        address indexed user,
        uint256 indexed amount,
        uint256 indexed timeStamp
    );

    uint256 constant AMOUNT_FUND = 10e18;
    address USER = makeAddr("paps");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        StakingPoolScript stakingPoolScript = new StakingPoolScript();
        stakingPool = stakingPoolScript.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testRevertIfAmountToStakeIsZero() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.stake(0, 1);
    }

    function testRevertIfOwnerBalanceIsLessThanAMountToStake() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.stake(30, 1);
    }

    function testRevertIfDurationIsNOtAvailable() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.stake(2, 7);
    }
    function testRevertIfDurationIsTooShort() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.stake(2, 0);
    }
    function testUserAlreadyHaveActiveStake() public {
        vm.deal(USER, AMOUNT_FUND * 5);
        vm.prank(USER);
        stakingPool.stake{value: 2 ether}(2, 2);

        vm.startPrank(USER);
        vm.expectRevert();
        stakingPool.stake{value: 2 ether}(2, 2);
        vm.stopPrank();
    }
    function testIfUserExistInLiastOfStakers() public {
        vm.deal(USER, AMOUNT_FUND * 3);
        vm.prank(USER);
        stakingPool.stake{value: AMOUNT_FUND}(2, 2);
        address funders = stakingPool.activeStaker(0);
        assertEq(funders, USER);
    }

    function testUserDetailGetUpdated() public {
        vm.deal(USER, AMOUNT_FUND * 3);
        vm.prank(USER);
        stakingPool.stake{value: AMOUNT_FUND}(AMOUNT_FUND, 2);
        StakingPool.Staker_Data memory userInfo = stakingPool.viewStakingDetail(
            USER
        );
        assertEq(userInfo.stakeAmount, AMOUNT_FUND);
        assertEq(userInfo.startTime, block.timestamp);
        assertEq(userInfo.isActive, true);
    }

    function testRevertIfUserHasNoStake() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.withdraw(2);
    }

    function testUserCanWithdraw() public {
        vm.deal(USER, AMOUNT_FUND * 3);
        vm.deal(address(stakingPool), 1 ether); // fund the contract with extra ether for reward
        vm.prank(USER);
        stakingPool.stake{value: AMOUNT_FUND}(AMOUNT_FUND, 1);
        vm.warp(block.timestamp + 8 days);
        vm.roll(block.number + 1);
        vm.prank(USER);
        stakingPool.withdraw(AMOUNT_FUND);
        StakingPool.Staker_Data memory userInfo = stakingPool.viewStakingDetail(
            USER
        );
        assertEq(userInfo.isActive, false);
    }

    function testRevertIfNoActiveStake() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.calculateWithdrawReward();
    }

    function testOnlyOwnerCanCallWthdrawProfit() public {
        vm.prank(USER);
        vm.expectRevert();
        stakingPool.withdrawProfit();
    }

    function testRevertUserTryWithdrawalMoreThanStake() public {
        vm.deal(USER, AMOUNT_FUND * 2);
        vm.prank(USER);
        stakingPool.stake{value: AMOUNT_FUND}(AMOUNT_FUND, 1);

        vm.warp(block.timestamp + 8 days);
        vm.roll(block.number + 1);

        vm.prank(USER);
        vm.expectRevert();
        stakingPool.withdraw(AMOUNT_FUND + 1 ether);
    }

    function testEventGeteEmittedAfterStake() public {
        vm.expectEmit(true, true, true, false, address(stakingPool));
        emit userHasStaked(USER, AMOUNT_FUND, block.timestamp);
        vm.prank(USER);
        vm.deal(USER, AMOUNT_FUND * 2);
        stakingPool.stake{value: AMOUNT_FUND}(AMOUNT_FUND, 1);
    }

    function testOwnerCanCallWithrawProfit() public {
        vm.deal(address(stakingPool), AMOUNT_FUND * 2);
        uint256 contractBalanceBefore = address(stakingPool).balance;
        vm.prank(stakingPool.Owner());
        stakingPool.withdrawProfit();
        uint256 contractBalanceAfter = address(stakingPool).balance;
        assertEq(contractBalanceAfter, 0);
        assertEq(contractBalanceBefore, AMOUNT_FUND * 2);
    }
}
