// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import EventTicket from "./EventTicket.sol";

contract EventFactory is Ownable{
    constructor() {
    }

    struct Event{
        uint256 id;
        string name;
        string description;
        string location;
        uint256 date;
        uint256 price;
        uint256 totalTickets;
        uint256 soldTickets;
        bool active;
        EventTicket[] EventTickets;
    }
}