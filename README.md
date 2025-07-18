## 📜 License

This project is licensed under the [MIT License](LICENSE).

# 🧠 StakingPool Smart Contract

A secure and flexible **Staking Pool** smart contract written in Solidity. This contract allows users to stake ETH for fixed durations and earn rewards based on APY (Annual Percentage Yield). It ensures only one active stake per user, enforces minimum/maximum durations, and prevents unauthorized access to key functions.

---

## 🔗 Features

- ✅ Fixed staking durations (1 week to 1 year)
- 📈 Dynamic APY per staking duration
- 🔒 Only one active stake per user
- ⏳ Lock-in staking period with automatic reward eligibility
- 🔐 Owner-only access to contract funds (withdraw profits)
- 🔄 View individual and global staking stats

---

## 📦 Staking Durations & APY

| Duration  | Internal Code | APY (%) |
| --------- | ------------- | ------- |
| 1 Week    | 1             | 5%      |
| 1 Month   | 2             | 8%      |
| 3 Months  | 3             | 12%     |
| 6 Months  | 4             | 15%     |
| 12 Months | 5             | 20%     |

---

## 🚀 How It Works

1. **Stake**:  
   Users call `stake(uint256 amount, uint256 durationCode)` with ETH and choose a staking period using one of the codes above.

2. **Withdraw**:  
   After the staking period, users can call `withdraw(uint256 amount)` to receive their initial stake + calculated reward.

3. **Reward Calculation**:  
   Reward = `(stakeAmount * APY) / 10000`, based on duration.

4. **Admin Withdrawal**:  
   The contract owner can call `withdrawProfit()` to collect excess funds (e.g. leftover balance from rounding or unclaimed rewards).

---

## 🧪 Error Handling

Custom errors are used to:

- Prevent multiple active stakes
- Ensure users send enough ETH
- Enforce staking period limits
- Protect owner-only functions
- Reject premature withdrawals

---

## 🔍 Available Functions

```solidity
function stake(uint256 _amountToStake, uint256 _stakingDuration) public payable;
function withdraw(uint256 _amount) public;
function calculateWithdrawReward() public view returns (uint256);
function withdrawProfit() public onlyOwner;
function viewStakingDetail(address _staker) public view returns (Staker_Data memory);
function totalStaked() public view returns (uint256);
function activeStaker() public view returns (address[] memory);
```

---

## 👷 Technologies

- Solidity ^0.8.0
- Ethereum-compatible chains
- Optimized for Foundry or Hardhat development

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
