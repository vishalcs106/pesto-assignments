// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./TyktoNft.sol";

contract TyktoMart is Ownable, AccessControl, Pausable, ReentrancyGuard {
    address public tyktoNftAddress;
    address public tyktoTokenAddress;

    bytes32 private constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    enum SaleStatus {
        ACTIVE,
        EXPIRED,
        CANCELLED,
        SOLD
    }

    mapping(address => SaleItem[]) public saleItems;

    uint256 public feePercentage = 5;

    struct SaleItem {
        uint256 ticketId;
        uint256 price;
        address seller;
        address buyer;
        uint256 duration;
        uint256 startTime;
        SaleStatus status;
    }

    constructor(address _tyktoNftAddress, address _tyktoTokenAddress) {
        tyktoNftAddress = _tyktoNftAddress;
        tyktoTokenAddress = _tyktoTokenAddress;
        _grantRole(PAUSER_ROLE, msg.sender);
    }

    event SaleItemCreated(
        address indexed ticketAddress,
        uint256 indexed tokenId,
        uint256 price,
        address indexed seller
    );
    event SaleCancelled(
        address indexed ticketAddress,
        uint256 indexed tokenId,
        address indexed seller
    );
    event ItemSold(
        address ticketAddress,
        uint256 indexed tokenId,
        uint256 price,
        address indexed seller,
        address indexed buyer
    );

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function setFeePercentage(
        uint256 _feePercentage
    ) external whenNotPaused onlyOwner {
        require(
            _feePercentage <= 100,
            "Fee percentage cannot be more than 100"
        );
        feePercentage = _feePercentage;
    }

    function listForSale(
        address ticketAddress,
        uint256 tokenId,
        uint256 amount,
        uint256 saleDuration
    ) public payable whenNotPaused {
        require(
            msg.sender == TyktoNft(ticketAddress).ownerOf(tokenId),
            "You are not the owner of this ticket"
        );
        SaleItem memory saleItem = SaleItem({
            ticketId: tokenId,
            price: amount,
            seller: msg.sender,
            buyer: address(0),
            duration: saleDuration,
            startTime: block.timestamp,
            status: SaleStatus.ACTIVE
        });
        saleItems[ticketAddress].push(saleItem);
        emit SaleItemCreated(ticketAddress, tokenId, amount, msg.sender);
    }

    function buyTicket(
        address ticketAddress,
        uint tokenId,
        uint256 amount
    ) public payable whenNotPaused {
        SaleItem[] storage saleItemList = saleItems[ticketAddress];
        SaleItem memory saleItem;
        uint256 itemIndex;
        for (uint i = 0; i < saleItemList.length; i++) {
            if (saleItemList[i].ticketId == tokenId) {
                itemIndex = i;
                saleItem = saleItemList[i];
                break;
            }
        }
        TyktoNft ticket = TyktoNft(ticketAddress);
        require(saleItem.status == SaleStatus.ACTIVE, "Ticket is not for sale");
        require(saleItem.price == amount, "Ticket price is not correct");
        require(msg.value == amount, "Incorrect amount sent");
        require(
            block.timestamp < saleItem.startTime + saleItem.duration,
            "Sale has expired"
        );
        require(
            msg.sender != saleItem.seller,
            "You cannot buy your own ticket"
        );
        require(
            ticket.ownerOf(tokenId) == saleItem.seller,
            "Seller does not own this ticket"
        );
        saleItem.buyer = msg.sender;
        saleItem.status = SaleStatus.SOLD;
        saleItemList[itemIndex] = saleItem;
        ticket.transferFrom(saleItem.seller, msg.sender, tokenId);

        (address creator, uint256 royaltyAmount) = ticket.royaltyInfo(
            tokenId,
            msg.value
        );

        uint256 platformFee = calculateMarketplaceFee();
        uint256 remainingAmount = msg.value - royaltyAmount - platformFee;
        payable(creator).transfer(royaltyAmount);
        payable(saleItem.seller).transfer(remainingAmount);
        emit ItemSold(
            ticketAddress,
            tokenId,
            amount,
            saleItem.seller,
            msg.sender
        );
    }

    function cancelListing(address ticketAddress, uint256 tokenId) public {
        SaleItem[] storage saleItemList = saleItems[ticketAddress];
        SaleItem memory saleItem;
        uint256 itemIndex;
        for (uint i = 0; i < saleItemList.length; i++) {
            if (saleItemList[i].ticketId == tokenId) {
                itemIndex = i;
                saleItem = saleItemList[i];
                break;
            }
        }
        require(saleItem.status == SaleStatus.ACTIVE, "Ticket is not for sale");
        require(
            msg.sender == saleItem.seller,
            "You are not the owner of this ticket"
        );
        saleItem.status = SaleStatus.CANCELLED;
        saleItemList[itemIndex] = saleItem;
        emit SaleCancelled(ticketAddress, tokenId, msg.sender);
    }

    function calculateMarketplaceFee() internal view returns (uint256) {
        return (msg.value * feePercentage) / 100;
    }
}
