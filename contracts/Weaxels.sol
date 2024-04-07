// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Weaxels is Ownable, ERC721A, ReentrancyGuard {

    string public CONTRACT_URI = "https://weaxels.s3.amazonaws.com/contract.json";
    string public BASE_URI = "";

    bool public REVEALED = false;
    string public UNREVEALED_URI = "https://weaxels.s3.amazonaws.com/unrevealed.json";

    bool public isMintEnabled = false;

    uint public COLLECTION_SIZE = 3888;
    uint public MINT_PRICE = 0.005 ether;
    uint public MAX_BATCH_SIZE = 10;

    constructor() ERC721A("Weaxel", "WXL") {}

    function teamMint(uint256 quantity, address receiver) public onlyOwner {
        require(
            totalSupply() + quantity <= COLLECTION_SIZE,
            "Max collection size reached!"
        );
        _safeMint(receiver, quantity);
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    function mint(uint256 quantity)
        external
        payable
        callerIsUser
    {
        uint256 price = (MINT_PRICE) * quantity;
        require(isMintEnabled == true, "Mint is not enabled");
        require(totalSupply() + quantity <= COLLECTION_SIZE, "Max collection size reached!");
        require(quantity <= MAX_BATCH_SIZE, "Tried to mint too many at once, please try with a lower quantity");
        require(msg.value >= price, "Not enough eth for mint");
        _safeMint(msg.sender, quantity);
        
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }

    function withdrawFunds() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function setIsMintEnabled(bool _isMintEnabled) public onlyOwner {
        isMintEnabled = _isMintEnabled;
    }

    function setBaseURI(bool _revealed, string memory _baseURI) public onlyOwner {
        BASE_URI = _baseURI;
        REVEALED = _revealed;
    }

    function contractURI() public view returns (string memory) {
        return CONTRACT_URI;
    }

    function setContractURI(string memory _contractURI) public onlyOwner {
        CONTRACT_URI = _contractURI;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (REVEALED) {
            return
                string(abi.encodePacked(BASE_URI, Strings.toString(_tokenId)));
        } else {
            return UNREVEALED_URI;
        }
    }
}
