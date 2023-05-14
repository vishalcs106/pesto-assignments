// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TyktoToken.sol";
import "./TyktoNft.sol";

/*
 * @author Vishal
 * @notice Smartcontarct to create Tykto Events and provide entry to the event by burning TyktoNFT
 */

contract TyktoPlatform is ReentrancyGuard, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private eventCounter;
    uint256 public eventCreationFee = 0.1 ether;
    TyktoToken public tyktoToken;
    address public tyktoTokenAddress;

    //@notice Constructor
    //@param _tyktoTokenAddress Address of TyktoToken
    constructor(address _tyktoTokenAddress) {
        eventCounter.increment();
        tyktoTokenAddress = _tyktoTokenAddress;
        tyktoToken = TyktoToken(_tyktoTokenAddress);
    }

    struct Event {
        uint256 id;
        string name;
        string description;
        string venue;
        uint256 startTime;
        uint256 endTime;
        address ticketAddress;
        bool isActive;
        bool isVerified;
        address owner;
    }

    mapping(address => Event[]) public activeEvents;

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    event EventCreated(
        address indexed ticketAddress,
        uint256 indexed eventId,
        string name,
        string description,
        string venue,
        uint256 startTime,
        uint256 endTime,
        address indexed creator
    );

    //@notice Create a new event
    //@param name Name of the event
    //@param description Description of the event
    //@param venue Venue of the event
    //@param startTime Start time of the event
    //@param endTime End time of the event
    //@param eventTicketAddress Address of the TyktoNFT
    function createEvent(
        string memory name,
        string memory description,
        string memory venue,
        uint256 startTime,
        uint256 endTime,
        address eventTicketAddress
    ) external payable whenNotPaused nonReentrant {
        require(
            msg.value >= eventCreationFee,
            "TyktoPlatform: Insufficient fee"
        );
        Event memory tyktoEvent = Event({
            id: eventCounter.current(),
            name: name,
            description: description,
            venue: venue,
            startTime: startTime,
            endTime: endTime,
            ticketAddress: eventTicketAddress,
            isActive: true,
            isVerified: false,
            owner: msg.sender
        });
        activeEvents[msg.sender].push(tyktoEvent);
        emit EventCreated(
            eventTicketAddress,
            tyktoEvent.id,
            name,
            description,
            venue,
            startTime,
            endTime,
            msg.sender
        );
        eventCounter.increment();
    }

    //notice Set event as inactive
    function setEventInactive(uint256 _eventId) public {
        Event[] storage events = activeEvents[msg.sender];
        for (uint256 i = 0; i < events.length; i++) {
            if (events[i].id == _eventId) {
                require(events[i].owner == msg.sender, "TyktoPlatform: You are not the owner of this event");
                events[i].isActive = false;
            }
        }
    }

    //@notice Set TyktoToken address
    function setTyktoTokenAddress(address _tyktoTokenAddress) public onlyOwner {
        tyktoTokenAddress = _tyktoTokenAddress;
    }

    //@notice Claim entry to the event
    //@param eventId Id of the event
    //@param tokenId Id of the TyktoNFT
    function claimEntry(
        uint256 eventId,
        uint256 tokenId
    ) public whenNotPaused nonReentrant {
        Event[] storage events = activeEvents[msg.sender];
        for (uint256 i = 0; i < events.length; i++) {
            if (events[i].id == eventId) {
                TyktoNft ticket = TyktoNft(events[i].ticketAddress);
                require(
                    ticket.balanceOf(msg.sender) > 0,
                    "TyktoPlatform: You do not own this ticket"
                );
                ticket.burn(tokenId);
                tyktoToken.transfer(msg.sender, 100);
                break;
            }
        }
    }

    //@notice Set event creation fee
    function setEventCreationFee(uint256 _eventCreationFee) public onlyOwner {
        eventCreationFee = _eventCreationFee;
    }

    //@notice Verify event
    function verifyEvent(uint256 _eventId) public onlyOwner {
        Event[] storage events = activeEvents[msg.sender];
        for (uint256 i = 0; i < events.length; i++) {
            if (events[i].id == _eventId) {
                events[i].isVerified = true;
            }
        }
    }

    //@notice Withdraw funds from the contract
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

}
