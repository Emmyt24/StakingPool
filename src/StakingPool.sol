//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingPool {
    error Stake_notEnoughFunds();
    error Stake__ChooseLongerPeriod();
    error Stake__ChooseShorterPeriod();
    error Staking__UnableToDeposit();
    error Staking__DurationNotAvailable();
    error Staking__WithrawalFailed();
    error Staking__NoActiveStake();
    error Staking__OnlyOwnerCanCall();
    error Staking__CantOverridePreviousStake();
    error Staking__MustStakeHigherThanZero();
    error Staking__YouHaveNoStake();

    uint256 private constant minimumStake = 1 ether;
    uint256 private constant SECONDS = 1;
    uint256 private constant MINUTE = 60;
    uint256 private constant HOUR = 3600;
    uint256 private constant DAYS = 86400;
    uint256 private constant WEEK = 604800;
    uint256 private constant MONTH = 259200;
    uint256 private constant YEAR = 31536000;
    address private owner;
    uint256 totalDeposited;

    uint256 public constant minimumStakingDuration = 1 * DAYS;
    uint256 public constant maximunStakingDuration = 363 * DAYS;

    address[] public listOfStakers;

    event userHasStaked(
        address indexed user,
        uint256 indexed amount,
        uint256 indexed timeStamp
    );
    event userHasWithdraw(address indexed user, uint256 indexed amount);

    mapping(address => Staker_Data) public stakers;
    mapping(uint256 => uint256) durationToAPY;
    mapping(uint256 => uint256) amountToTime;
    struct Staker_Data {
        uint256 stakeAmount;
        uint256 stakeTime;
        bool isActive;
        uint256 startTime;
        uint256 endTime;
    }
    // Set default reward rates for common durations
    constructor() {
        owner = msg.sender;
        durationToAPY[7 * DAYS] = 500; // 1 week = 5% APY
        durationToAPY[30 * DAYS] = 800; // 1 month = 8% APY
        durationToAPY[90 * DAYS] = 1200; // 3 months = 12% APY
        durationToAPY[180 * DAYS] = 1500; // 6 months = 15% APY
        durationToAPY[365 * DAYS] = 2000; // 1 year = 20% APY
    }

    // function to stake your coin
    function stake(
        uint256 _amountToStake,
        uint256 _stakingDuration
    ) public payable {
        uint256 duration;
        Staker_Data storage user = stakers[msg.sender];
        if (_stakingDuration == 1) {
            duration = 7 * DAYS;
        } else if (_stakingDuration == 2) {
            duration = 30 * DAYS;
        } else if (_stakingDuration == 3) {
            duration = 90 * DAYS;
        } else if (_stakingDuration == 4) {
            duration = 180 * DAYS;
        } else if (_stakingDuration == 5) {
            duration = 365 * DAYS;
        } else {
            revert Staking__DurationNotAvailable();
        }
        if (_amountToStake <= 0) {
            revert Staking__MustStakeHigherThanZero();
        }
        if (msg.value < _amountToStake) {
            revert Stake_notEnoughFunds();
        }
        if (duration <= minimumStakingDuration) {
            revert Stake__ChooseLongerPeriod();
        }
        if (duration > maximunStakingDuration) {
            revert Stake__ChooseShorterPeriod();
        }
        if (user.isActive == true) {
            revert Staking__CantOverridePreviousStake();
        }

        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + duration;

        stakers[msg.sender] = Staker_Data({
            stakeAmount: _amountToStake,
            stakeTime: block.timestamp,
            isActive: true,
            startTime: startTime,
            endTime: endTime
        });
        amountToTime[_amountToStake] += block.timestamp;
        listOfStakers.push(msg.sender);

        emit userHasStaked(msg.sender, _amountToStake, _stakingDuration);
    }

    //withdrawal function your stake

    function withdraw(uint256 _amount) public {
        require(msg.sender.balance > 0);
        Staker_Data storage user = stakers[msg.sender];
        if (user.isActive != true) {
            revert Staking__YouHaveNoStake();
        }
        require(
            user.isActive && block.timestamp > user.endTime,
            "Staking period has not ended yet"
        );

        uint256 reward = calculateWithdrawReward();
        user.stakeAmount -= _amount;

        if (user.stakeAmount == 0) {
            user.isActive = false;
        }

        (bool sent, ) = payable(msg.sender).call{value: _amount + reward}("");
        if (!sent) {
            revert Staking__WithrawalFailed();
        }

        emit userHasWithdraw(msg.sender, _amount + reward);
    }

    //calculate Reward

    function calculateWithdrawReward() public view returns (uint256 reward) {
        Staker_Data storage user = stakers[msg.sender];
        if (user.isActive != true) {
            revert Staking__NoActiveStake();
        }
        uint256 stakingDuration = user.endTime - user.startTime;
        uint256 apy = durationToAPY[stakingDuration]; // in basis points (e.g. 500 = 5%)
        reward = (user.stakeAmount * apy) / 10000;
    }

    //withdraw profit from the contract

    function withdrawProfit() public onlyOwner {
        (bool sent, ) = payable(owner).call{value: address(this).balance}("");
        if (!sent) {
            revert Staking__WithrawalFailed();
            //revert
        }
    }
    // to view all stakersss
    //to view stakers detail
    function viewStakingDetail(
        address _staker
    ) public view returns (Staker_Data memory) {
        Staker_Data storage userInfo = stakers[_staker];
        return userInfo;
    }

    // to view total stake
    function totalStaked() public view returns (uint256) {
        return address(this).balance;
    }

    // to view active stakers
    function activeStaker(uint256 index) public view returns (address) {
        return listOfStakers[index];
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Staking__OnlyOwnerCanCall();
        }
        _;
    }
}
