// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TyktoPlatform is ReentrancyGuard, Pausable, Ownable{

    using Counters for Counters.Counter;
    
    Counters.Counter private eventCounter;

    constructor() {
        eventCounter.increment();
    }

    struct Event{
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

    event EventCreated(address indexed ticketAddress, uint256 indexed eventId, string name, string description, string venue, uint256 startTime, uint256 endTime, address indexed creator);

    function createEvent(string memory name, string memory description, string memory venue, uint256 startTime, uint256 endTime) 
    whenNotPaused
    public {
        Event memory tyktoEvent = Event({
            id: eventCounter.current(),
            name: name,
            description: description,
            venue: venue,
            startTime: startTime,
            endTime: endTime,
            ticketAddress: address(0),
            isActive: true,
            isVerified: false
        });
        activeEvents[msg.sender].push(tyktoEvent);
        emit EventCreated(address(0), tyktoEvent.id, name, description, venue, startTime, endTime, msg.sender);
        eventCounter.increment();
    }

}