## ONCHAIN VOTING SYSTEM

> > VotingSystem is a decentralized voting smart contract written in Solidity. It enables a secure, tamper-proof election where:

> > Only the contract owner can register candidates.

> > Voters can vote only once.

> > Results are automatically calculated based on vote count.

> > Voting state can be started or stopped by the owner.

**This contract is ideal for learning access control, enums, structs, mappings, modifiers, and dynamic state logic in Solidity.**

## ✨ Features

✅ Add Candidates – Only the owner can register new candidates.

✅ Start/Stop Voting – Voting must be started before votes are accepted.

✅ Vote Once – Each voter can vote only once. Duplicates are rejected.

✅ Declare Winner – Dynamically checks which candidate has the highest votes.

✅ Custom Errors – Gas-efficient error handling.

✅ Events – Emits event every time someone votes for easy frontend tracking.

## 🧠 Smart Contract Concepts Used

Concept Usage

> struct Store candidate info
> enum Manage voting state (START/STOP)
> mapping Track votes per candidate
> modifier Restrict access (OnlyOwner, votingCheck)
> custom errors Gas-efficient reverts
> event Log voter activity

## 🛠️ How It Works

1. Owner Adds Candidate
   solidity
   Copy
   Edit
   addCandidate(address \_candidate, uint256 id)

2. Start Voting
   Voting automatically starts when the first candidate is added. You can extend the logic to call startVoting() explicitly.

3. User Votes
   solidity
   Copy
   Edit
   vote(uint256 id)
   Each voter is added to a voters[] array to prevent duplicate voting.

4. Declare Winner
   solidity
   Copy
   Edit
   declareWinner()
   Returns the candidate with the highest number of votes.

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
