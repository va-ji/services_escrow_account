// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Escrow {
    //variables
    address public buyer;
    address payable public seller;
    uint256 amountDeposited;
    uint256 public price;
    address public dispute1;
    address public dispute2;
    enum transactionState {
        NOT_INITIATED,
        AWAITING_PAYMENT,
        AWAITING_DELIVERY,
        COMPLETE,
        DISPUTE
    }
    transactionState public currentState;
    bool public isBuyerIn;
    bool public isSellerIn;

    //modifiers

    modifier buyerOnly() {
        require(msg.sender == buyer, "Only buyer can call message");
        _;
    }

    modifier sellerOnly() {
        require(msg.sender == seller, "Only seller can call the message");
        _;
    }

    modifier escrowNotInit() {
        require(currentState == transactionState.NOT_INITIATED);
        _;
    }

    //constructor
    constructor(
        address _buyer,
        address payable _seller,
        uint256 _price,
        address _dispute1,
        address _dispute2
    ) {
        buyer = _buyer;
        seller = _seller;
        price = _price * (1 ether);
        dispute1 = _dispute1;
        dispute2 = _dispute2;
    }

    //functions

    function initEscrow() public escrowNotInit {
        if (msg.sender == buyer) {
            isBuyerIn = true;
        }
        if (msg.sender == seller) {
            isSellerIn = true;
        }
        if (isBuyerIn && isSellerIn) {
            currentState = transactionState.AWAITING_PAYMENT;
        }
    }

    function deposit() public payable buyerOnly {
        require(currentState == transactionState.AWAITING_PAYMENT);
        require(msg.value == price, "Wrong deposited amount");
        currentState = transactionState.AWAITING_DELIVERY;
    }

    function confirmDelivery() public payable buyerOnly {
        require(
            currentState == transactionState.AWAITING_DELIVERY,
            "Cannot confirm delivery"
        );
        seller.transfer(price);
        currentState = transactionState.COMPLETE;
    }

    function returnDeposit() public payable buyerOnly {
        require(
            currentState == transactionState.AWAITING_DELIVERY,
            "Cannot withdraw at this stage"
        );
        payable(msg.sender).transfer(price);
        currentState = transactionState.COMPLETE;
    }

    function callDispute() public {
        if (msg.sender == buyer || msg.sender == seller) {
            currentState = transactionState.DISPUTE;
        }
    }

    // function handleDisputes() public {
    //     require(currentState == transactionState.DISPUTE);

    // }
}
