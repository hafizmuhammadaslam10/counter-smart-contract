# 🔢 Counter Smart Contract

A production-ready, fully-tested smart contract project built with Hardhat, demonstrating best practices in Solidity development, testing, and deployment.

![Solidity](https://img.shields.io/badge/Solidity-0.8.28-363636?logo=solidity&logoColor=white)
![Hardhat](https://img.shields.io/badge/Hardhat-3.1.3-F7DF1E?logo=hardhat&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6?logo=typescript&logoColor=white)
![Viem](https://img.shields.io/badge/Viem-2.44.1-6366F1?logo=ethereum&logoColor=white)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Testing](#testing)
- [Deployment](#deployment)
- [Smart Contract Details](#smart-contract-details)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project implements a simple yet robust **Counter** smart contract on Ethereum, showcasing:

- ✅ Clean, secure Solidity code with proper error handling
- ✅ **Access control** with owner-only administrative functions
- ✅ **Enhanced events** (Increment, Decrement, DataStored, OwnershipTransferred, CounterReset)
- ✅ Comprehensive test coverage (13 tests: 3 Solidity + 10 TypeScript)
- ✅ Event-driven architecture for off-chain monitoring
- ✅ **Full NatSpec documentation** for all functions and events
- ✅ Production-ready deployment pipeline
- ✅ Multi-network support (local, Sepolia testnet)
- ✅ Modern development tooling (Hardhat, Viem, TypeScript)

The Counter contract allows users to increment and decrement a value, with built-in safeguards to prevent underflow errors and emit events for all state changes. The contract includes access control for administrative functions and comprehensive NatSpec documentation.

## ✨ Features

### Smart Contract Features
- **Increment Operations**: Increment counter by 1 or by a custom amount
- **Decrement Operations**: Decrement counter by 1 or by a custom amount
- **Access Control**: Owner-only functions for administrative tasks (reset, setValue, storeData)
- **Safety Checks**: Prevents underflow and overflow with `require` statements
- **Event Emission**: Emits enhanced events (`Increment`, `Decrement`, `DataStored`, `OwnershipTransferred`, `CounterReset`) for all operations
- **Public State**: Counter value is publicly readable
- **Ownership Management**: Transfer ownership functionality with event tracking
- **Comprehensive Documentation**: Full NatSpec comments for all functions and events

### Development Features
- **Dual Testing Framework**: 
  - Foundry-compatible Solidity tests (`Counter.t.sol`)
  - TypeScript integration tests using Node.js native test runner
- **Hardhat Ignition**: Modern deployment system with module support
- **Multi-Network Support**: Configured for local development and Sepolia testnet
- **Type Safety**: Full TypeScript support with Viem for type-safe contract interactions
- **Deployment Scripts**: Automated scripts to view and manage deployed contracts

## 🛠️ Tech Stack

- **Solidity** `^0.8.28` - Smart contract language
- **Hardhat** `^3.1.3` - Ethereum development environment
- **TypeScript** `~5.8.0` - Type-safe JavaScript
- **Viem** `^2.44.1` - TypeScript Ethereum library
- **Hardhat Ignition** `^3.0.6` - Deployment system
- **Node.js Test Runner** - Native testing framework
- **Foundry** - Solidity testing framework (via forge-std)

## 📁 Project Structure

```
hardhat/
├── contracts/
│   ├── Counter.sol          # Main smart contract
│   └── Counter.t.sol         # Solidity unit tests
├── test/
│   └── Counter.ts            # TypeScript integration tests
├── scripts/
│   ├── deploy.ts             # View deployed contract addresses
│   └── send-op-tx.ts         # Additional utility scripts
├── ignition/
│   └── modules/
│       └── Counter.ts        # Ignition deployment module
├── artifacts/                # Compiled contract artifacts
├── cache/                    # Hardhat cache
├── hardhat.config.ts         # Hardhat configuration
├── package.json              # Dependencies and scripts
└── tsconfig.json             # TypeScript configuration
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** >= 18.x
- **npm** or **yarn**
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd hardhat
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables** (for testnet deployment)
   
   Create a `.env` file in the root directory:
   ```env
   SEPOLIA_RPC_URL=your_sepolia_rpc_url
   SEPOLIA_PRIVATE_KEY=your_private_key
   ```

   ⚠️ **Security Note**: Never commit your `.env` file or private keys to version control!

## 💻 Usage

### Compile Contracts

```bash
npm run compile
# or
npx hardhat compile
```

### Run Tests

Run all tests (Solidity + TypeScript):
```bash
npm test
# or
npx hardhat test
```

Run only Solidity tests:
```bash
npx hardhat test solidity
```

Run only TypeScript/Node.js tests:
```bash
npx hardhat test nodejs
```

### Deploy to Local Network

1. **Start a local Hardhat node** (in a separate terminal):
   ```bash
   npx hardhat node
   ```

2. **Deploy the contract**:
   ```bash
   npx hardhat ignition deploy ignition/modules/Counter.ts
   ```

### Deploy to Sepolia Testnet

1. **Ensure your `.env` file is configured** with Sepolia RPC URL and private key

2. **Deploy to Sepolia**:
   ```bash
   npm run deploy
   # or
   npx hardhat ignition deploy ignition/modules/Counter.ts --network sepolia --reset
   ```

3. **View deployed addresses**:
   ```bash
   npx hardhat run scripts/deploy.ts
   ```

   This will display all deployed contract addresses and save them to `deployments.json`.

## 🧪 Testing

The project includes comprehensive test coverage:

### Solidity Tests (`Counter.t.sol`)
- Unit tests written in Solidity using Foundry-style assertions
- Tests contract logic directly on-chain

### TypeScript Tests (`test/Counter.ts`)
- Integration tests using Node.js native test runner
- Tests event emission and state changes
- Validates event aggregation matches contract state
- Uses Viem for type-safe contract interactions

### Test Coverage
- ✅ Increment functionality (single and by amount)
- ✅ Decrement functionality (single and by amount)
- ✅ Event emission verification (Increment, Decrement, DataStored)
- ✅ Underflow prevention
- ✅ State consistency checks
- ✅ Access control (owner verification)
- ✅ Owner-only functions (storeData, reset, transferOwnership)
- ✅ Unauthorized access prevention
- ✅ Ownership transfer functionality
- ✅ **Total: 13 tests passing (3 Solidity + 10 TypeScript)**

## 🚢 Deployment

### Deployment Module

The project uses Hardhat Ignition for deployments. The `Counter.ts` module:
- Deploys the Counter contract
- Performs an initial `incBy(5)` call to demonstrate contract interaction

### Networks Supported

- **Hardhat Local Network** (`localhost:8545`)
- **Sepolia Testnet** (configured via environment variables)
- **EDR Simulated Networks** (for advanced testing)

### Viewing Deployments

After deployment, use the deployment script to view all deployed addresses:

```bash
npx hardhat run scripts/deploy.ts
```

Output includes:
- Network name and Chain ID
- Contract address
- Saved to `deployments.json` for reference

## 📄 Smart Contract Details

### Counter Contract

**Location**: `contracts/Counter.sol`

**State Variables**:
- `uint public x` - The counter value (publicly readable)
- `address public owner` - The contract owner address

**Public Functions**:
- `inc()` - Increment counter by 1 (anyone can call)
- `dec()` - Decrement counter by 1 (reverts if x == 0, anyone can call)
- `incBy(uint by)` - Increment counter by specified amount (anyone can call)
- `decBy(uint by)` - Decrement counter by specified amount (reverts if x < by, anyone can call)
- `getValue()` - Get current counter value (view function)
- `isOwner(address account)` - Check if an address is the owner (view function)

**Owner-Only Functions**:
- `storeData(string memory data)` - Store data string (owner-only, emits DataStored event)
- `reset()` - Reset counter to zero (owner-only, emits CounterReset event)
- `setValue(uint newValue)` - Set counter to specific value (owner-only)
- `transferOwnership(address newOwner)` - Transfer contract ownership (owner-only, emits OwnershipTransferred event)

**Events**:
- `Increment(uint indexed by, uint newValue)` - Emitted when counter is incremented (includes new value)
- `Decrement(uint indexed by, uint newValue)` - Emitted when counter is decremented (includes new value)
- `DataStored(string indexed data, uint256 timestamp)` - Emitted when owner stores data
- `OwnershipTransferred(address indexed previousOwner, address indexed newOwner)` - Emitted when ownership changes
- `CounterReset(uint previousValue)` - Emitted when counter is reset by owner

**Security Features**:
- Access control via `onlyOwner` modifier for administrative functions
- Underflow and overflow protection via `require` statements
- Input validation for all function parameters
- Custom errors (`Unauthorized`, `InvalidInput`) for gas-efficient error handling
- Zero address checks for ownership transfers
- Clear error messages for debugging
- Comprehensive NatSpec documentation

### Example Usage

```solidity
// Deploy contract (deployer becomes owner)
Counter counter = new Counter();

// Public functions (anyone can call)
counter.inc();              // Increment by 1
counter.incBy(10);          // Increment by 10
counter.dec();              // Decrement by 1
counter.decBy(5);           // Decrement by 5

// Read current value
uint currentValue = counter.x();
// or
uint value = counter.getValue();

// Owner-only functions (only owner can call)
counter.storeData("Important data");  // Store data
counter.reset();                      // Reset counter to 0
counter.setValue(100);                // Set counter to 100
counter.transferOwnership(newOwner);   // Transfer ownership

// Check ownership
bool isOwner = counter.isOwner(msg.sender);
address contractOwner = counter.owner();
```

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Solidity style guide conventions
- Write tests for new features
- Ensure all tests pass before submitting PR
- Update documentation as needed

## 📝 License

This project is licensed under the UNLICENSED license. See the contract source code for details.

## 👤 Author

**Hafiz Muhammad Aslam**

- GitHub: [@hafizmuhammadaslam10](https://github.com/hafizmuhammadaslam10/)
- LinkedIn: [Hafiz Muhammad Aslam](https://www.linkedin.com/in/hafiz-muhammad-aslam/)

---

## 🙏 Acknowledgments

- [Hardhat](https://hardhat.org/) - Ethereum development environment
- [Viem](https://viem.sh/) - TypeScript Ethereum library
- [Foundry](https://book.getfoundry.sh/) - Solidity testing framework

---

⭐ **If you found this project helpful, please consider giving it a star!**
