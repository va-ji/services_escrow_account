// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Escrow {
    //variables
    address public agent;
    enum transactionState {
        NOT_INITIATED,
        AWAITING_PAYMENT,
        AWAITING_DELIVERY,
        COMPLETE
    }

    //modifiers
    modifier agentOnly() {
        require(msg.sender == agent);
        _;
    }

    modifier buyerOnly() {
        _;
    }

    modifier sellerOnly() {
        _;
    }

    //constructor
    constructor() {
        agent = msg.sender;
    }

    //functions

    function initEscrow() public {}

    function withdraw() public {}

    function deposit() public {}

    function verify() public {}

    function returnDeposit() public {}
}
