# Weaxels

# Overview

This is a smart contract for Ethereum.

## Features
- **ERC721A Token Standard:** This utilizes the ERC721A implementation for optimized gas costs on minting multiple NFTs in a single transaction. 
- **Ownership and Security:** Integrates OpenZeppelin's `Ownable` and `ReentrancyGuard` contracts for secure ownership management and protection against re-entrancy attacks.
- **Mint On/Off Toggle:** You can turn on/off if mint is enabled. 
- **Immutable max supply:** The contract can't change the max supply after deployment.
- **Immutable price:** The contract can't change the price of mint after deployment.
- **Refunds if overpay:** The contract refunds extra ether if overpaid.


## Functions

### teamMint(uint256 quantity, address receiver)
- Allows the contract owner to mint a specified quantity of tokens to a receiver address. This function enforces the collection size limit. This can mint even if isMintEnabled is toggled off. 

### mint(uint256 quantity)
- Public function enabling users to mint tokens if mint is enabled. It includes several checks for minting conditions such as minting status, collection size limit, batch size limit, and sufficient payment. Overpaid ether is refunded.

### setIsMintEnabled(bool _isMintEnabled)
- Toggles the public minting functionality on or off.

### setBaseURI(string memory _baseURI)
- Sets the base URI for the token metadata. This function allows the contract owner to update the metadata path. Remember to include a trailing slash (`/`) at the end because the tokenURI function doesn't append a trailing slash.

### setContractURI(string memory _contractURI)
- Sets the contract metadata URI. 

### withdrawFunds()
- Withdraws all the ethereum from the contract to the owner's address. This function is protected against re-entrancy attacks.

### tokenURI(uint256 _tokenId)
- Overrides the ERC721A tokenURI method to return the full metadata URI for a given token ID, concatenating the base URI and the token ID. 
