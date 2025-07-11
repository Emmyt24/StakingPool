//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract MiniBank {
    uint256 minimumBalance = 0.001 ether;
    error MiniBank__NotEnoughEth();
    error MiniBank__NotRegistered();
    error MiniBank__MinimumMustBeGreaterThanZero();
    error MiniBank__BalanceMustBeGreaterThanAmount();

    event Deposit(address indexed funder, uint256 amount);
    event Withdraw(address indexed funder, uint256 amount);

    struct User {
        uint256 balance;
        bool isRegistered;
    }

    mapping(address => User) public addressToUser;
    // Removed unused senderToValue mapping
    address[] public registeredDepositors;

    function register() public payable {
        if (msg.sender.balance < minimumBalance) {
            revert MiniBank__NotEnoughEth();
        }

        addressToUser[msg.sender] = User({
            balance: msg.sender.balance,
            isRegistered: true
        });
    }

    function deposit() public payable onlyRegistered {
        if (msg.sender.balance < minimumBalance) {
            revert MiniBank__NotEnoughEth();
        }

        if (msg.value <= 0) {
            revert MiniBank__MinimumMustBeGreaterThanZero();
        }

        addressToUser[msg.sender].balance += msg.value;
        registeredDepositors.push(msg.sender);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public payable {
        if (addressToUser[msg.sender].balance < amount) {
            revert MiniBank__BalanceMustBeGreaterThanAmount();
        }
        if (amount <= 0) {
            revert MiniBank__MinimumMustBeGreaterThanZero();
        }
        addressToUser[msg.sender].balance -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success);
        emit Withdraw(msg.sender, amount);
    }

    function checkBalance(
        address
    ) public view onlyRegistered returns (uint256) {
        return addressToUser[msg.sender].balance;
    }

    modifier onlyRegistered() {
        if (!addressToUser[msg.sender].isRegistered) {
            revert MiniBank__NotRegistered();
        }
        _;
    }
}
