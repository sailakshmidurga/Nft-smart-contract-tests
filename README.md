# **NftCollection – ERC721 NFT Smart Contract**

This repository contains a complete ERC-721–compatible NFT smart contract implementation, an automated Hardhat test suite, and a fully containerized Docker environment for reproducible evaluation.

The project follows all requirements from the assignment:

* smart contract in `contracts/`
* automated tests in `test/`
* Dockerfile for isolated execution
* no frontend or web components
* zero manual steps required in container

---

## 📌 Features

### **Smart Contract**

* ERC-721 compliant using OpenZeppelin.
* Immutable `maxSupply` ensuring supply limits.
* Owner-only minting (`safeMint`).
* Burning support (`burn`).
* Pausable transfers and minting (`pause`, `unpause`).
* Custom `tokenURI` override.
* Prevents double-minting of tokenIds.
* Enforces valid tokenId ranges.

---

## 📁 Project Structure

```
nft-assignment/
│── contracts/
│     └── NftCollection.sol
│── test/
│     └── NftCollection.test.js
│── hardhat.config.js
│── package.json
│── Dockerfile
│── .dockerignore
│── README.md
```

---

## 🧰 Tech Stack

* **Solidity 0.8.28**
* **Hardhat**
* **Node.js**
* **OpenZeppelin Contracts v4.9.3**
* **Ethers.js + Chai** (testing)
* **Docker** (isolated evaluation)

---

## 📜 Contract Overview

### **Constructor**

```solidity
constructor(
    string memory name_,
    string memory symbol_,
    uint256 maxSupply_
)
```

### **Key Functions**

| Function                                | Description                           |
| --------------------------------------- | ------------------------------------- |
| `safeMint(address to, uint256 tokenId)` | Owner-only minting with bounds checks |
| `burn(uint256 tokenId)`                 | Burn existing NFT                     |
| `pause()` / `unpause()`                 | Pause or resume transfers + minting   |
| `tokenURI(uint256 tokenId)`             | Returns the token metadata URI        |
| `maxSupply`                             | Immutable upper supply limit          |

---

## 🧪 Running Tests (Local)

### **Compile**

```bash
npx hardhat compile
```

### **Run tests**

```bash
npx hardhat test
```

Expected output:

```
5 passing
```

Tests include:

* deployment
* owner minting
* non-owner rejection
* pause/unpause behavior
* tokenURI correctness
* supply enforcement

---

## 🐳 Docker Instructions

The included Dockerfile enables reproducible execution without installing Hardhat manually.

### **Build image**

```bash
docker build -t nft-contract .
```

### **Run tests inside container**

```bash
docker run --rm nft-contract
```

The container will:

* install dependencies
* compile the contract
* run the full Hardhat test suite

All tests must pass for evaluation.

---

## ▶️ How Evaluators Can Verify

```bash
docker build -t nft-contract .
docker run --rm nft-contract
```

No additional steps, keys, or external network required.

---

## 👩‍💻 Author

**Sai Lakshmi Durga Koneti**
