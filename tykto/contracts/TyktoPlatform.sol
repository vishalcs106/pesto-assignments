// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TyktoToken.sol";

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

    function createEvent(
        string memory name,
        string memory description,
        string memory venue,
        uint256 startTime,
        uint256 endTime,
        address eventTicketAddress
    ) public whenNotPaused onlyOwner nonReentrant {
        require(msg.value >= eventCreationFee, "TyktoPlatform: Insufficient fee");
        Event memory tyktoEvent = Event({
            id: eventCounter.current(),
            name: name,
            description: description,
            venue: venue,
            startTime: startTime,
            endTime: endTime,
            ticketAddress: eventTicketAddress,
            isActive: true,
            isVerified: false
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

    function setEventInactive(uint256 _eventId) public {
        Event[] storage events = activeEvents[msg.sender];
        for (uint256 i = 0; i < events.length; i++) {
            if (events[i].id == _eventId) {
                events[i].isActive = false;
            }
        }
    }

    function setTyktoTokenAddress(address _tyktoTokenAddress) public onlyOwner {
        tyktoTokenAddress = _tyktoTokenAddress;
    }

    function claimEntry(uint256 eventId, uint256 tokenId) public whenNotPaused nonReentrant {
        Event[] storage events = activeEvents[msg.sender];
        for (uint256 i = 0; i < events.length; i++) {
            if (events[i].id == eventId) {
                TyktoNft ticket = TyktoNft(events[i].ticketAddress);
                require(ticket.balanceOf(msg.sender) > 0, "TyktoPlatform: You do not own this ticket");
                ticket.burn(msg.sender, address(this), tokenId);
                tyktoToken.transfer(msg.sender, 100);
                break;
            }
        }
    }


function setEventCreationFee(uint256 _eventCreationFee) public onlyOwner {
        eventCreationFee = _eventCreationFee;
    }
}
