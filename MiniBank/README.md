## 🏦 MiniBank Smart Contract

**📄 Overview**

MiniBank is a decentralized Ethereum smart contract written in Solidity that simulates core banking operations on-chain. It allows users to:

Register as a bank customer

Deposit ETH into their personal MiniBank balance

Withdraw ETH from their balance

Check their balance

View the total ETH held by the bank

This contract enforces user registration before any banking actions and uses modifiers, events, and custom errors to ensure security, traceability, and gas efficiency.

## ⚙️ Features

✅ User Registration: Only registered users can deposit or withdraw.

✅ Deposit ETH: Users can deposit ETH into their account.

✅ Withdraw ETH: Users can withdraw from their MiniBank balance.

✅ Track Balances: Users can check their own balance.

✅ Bank Reserve: View the total balance held in the contract.

✅ Custom Errors: Gas-optimized error handling.

✅ Events: Deposit and Withdraw events for off-chain tracking.

✅ Access Control: Modifier onlyRegistered restricts unauthorized actions.

## 🔐 Contract Security & Logic

Balance Tracking: Each user has an internal balance (User.balance) separate from their wallet.

Minimum Deposit: A minimum of 0.001 ETH is required to register or deposit.

Revert Conditions:

Attempting to deposit/withdraw without registering.

Sending zero or insufficient ETH.

Withdrawing more than your balance.

## 📦 Contract Details

## Item Description

> > Solidity Version ^0.8.15

> > License MIT

> > Contract Name MiniBank

> > Entry Functions register, deposit, withdraw

> > View Functions checkBalance, getMainBalance

> > Events Deposit, Withdraw

> > > Modifiers onlyRegistered

> > Errors MiniBank**NotRegistered, MiniBank**NotEnoughEth, MiniBank\_\_BalanceMustBeGreaterThanAmount, etc.

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
