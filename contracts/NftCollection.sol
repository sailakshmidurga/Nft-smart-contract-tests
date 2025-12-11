// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NftCollection is ERC721, Ownable, Pausable {
    using Strings for uint256;

    uint256 public immutable maxSupply;  
    uint256 public totalSupply;          
    string private baseURI_;             

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        string memory baseURIArg
    ) ERC721(name_, symbol_) {
        require(maxSupply_ > 0, "maxSupply > 0");
        maxSupply = maxSupply_;
        baseURI_ = baseURIArg;
    }

    // -----------------------------------------------------
    // Admin functions
    // -----------------------------------------------------

    function setBaseURI(string memory newBase) external onlyOwner {
        baseURI_ = newBase;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // -----------------------------------------------------
    // Minting
    // -----------------------------------------------------

    function safeMint(address to, uint256 tokenId)
        external
        onlyOwner
        whenNotPaused
    {
        require(to != address(0), "zero address");
        require(tokenId >= 1 && tokenId <= maxSupply, "invalid tokenId");
        require(!_exists(tokenId), "already minted");
        require(totalSupply < maxSupply, "max supply reached");

        _safeMint(to, tokenId);
        unchecked { totalSupply += 1; }
    }

    // -----------------------------------------------------
    // Burn (optional but required for tests)
    // -----------------------------------------------------

    function burn(uint256 tokenId) external whenNotPaused {
        address owner = ownerOf(tokenId);
        require(
            msg.sender == owner ||
            msg.sender == getApproved(tokenId) ||
            isApprovedForAll(owner, msg.sender),
            "not owner/approved"
        );

        _burn(tokenId);
        unchecked { totalSupply -= 1; }
    }

    // -----------------------------------------------------
    // tokenURI
    // -----------------------------------------------------

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "nonexistent");

        string memory base = baseURI_;
        return string(abi.encodePacked(base, "/", tokenId.toString(), ".json"));
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI_;
    }

    // -----------------------------------------------------
    // Pause transfers also
    // -----------------------------------------------------

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}
