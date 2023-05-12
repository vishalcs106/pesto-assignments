// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EventTicket is ERC721 {
    constructor() ERC721("Event", "EVT") {
    }

    struct EventTicket {
        uint256 id;
        string name;
        string description;
        string location;
        uint256 date;
        uint256 price;
        uint256 totalTickets;
        uint256 soldTickets;
        bool active;
    }
}


