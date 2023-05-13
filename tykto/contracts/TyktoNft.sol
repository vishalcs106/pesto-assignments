// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract TyktoNft is
    ERC721,
    ERC721URIStorage,
    ERC2981,
    Pausable,
    Ownable,
    ERC721Burnable,
    ReentrancyGuard
{
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private tokenIdCounter;

    uint public mintPrice = 0.1 ether;
    uint public maxSupply;
    uint public baseUri;

    uint public royaltyFeeInBips = 500;
    address royaltyAddress;

    constructor() ERC721("TyktoNft", "TykNft") {
        royaltyAddress = msg.sender;
    }

    function updateMintPrice(uint256 newMintPrice) public onlyOwner {
        mintPrice = newMintPrice;
    }

    function updateMaxSupply(uint256 newMaxSupply) public onlyOwner {
        maxSupply = newMaxSupply;
    }

    function updateBaseUri(uint256 newBaseUri) public onlyOwner {
        baseUri = newBaseUri;
    }

    function updateRoyaltyAddress(address newRoyaltyAddress) public onlyOwner {
        royaltyAddress = newRoyaltyAddress;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public payable {
        require(msg.value >= mintPrice, "Not enough ETH sent; check price!");
        require(tokenIdCounter.current() < maxSupply, "Max supply reached");
        _safeMint(to, tokenIdCounter.current());
        _setTokenURI(tokenIdCounter.current(), uri);
        tokenIdCounter.increment();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) public view override returns (address, uint256) {
        return (royaltyAddress, calculateRoyalty(_salePrice));
    }

    function calculateRoyalty(
        uint256 _salePrice
    ) public view returns (uint256) {
        return (_salePrice / 10000) * royaltyFeeInBips;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
