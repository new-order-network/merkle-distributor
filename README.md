# Updateable @uniswap/merkle-distributor with SafeERC & test coverage

Originally forked from https://github.com/Uniswap/merkle-distributor

Then we:
* Added SafeERC capabilities for non-standard tokens
* Added full test coverage / reports

*NEW Update:* Added Ownable, and the ability of the Owner to:
* Withdraw tokens
* Update the Merkle Root
* Pause/UnPause claims

If the Merkle Root is updated to assign additional airdropped tokens to a particular address that address will be able to claim an amount of tokens equal to the new allocation *minus* the number of tokens previously claimed. 

## Important Notes:
* It's assumed *Owner* knows what they are doing and is trustable as well - likely a multisig.
* It's assumed that a particular address appears in the MerkleTree ONCE at most
## Installation:
### Hardhat
```bash
yarn add global hardhat 
```

## Running test
### Testing 

#### 1. Running hardhat node
running hardhat node in your terminal
```bash
npx hardhat node
```
#### 2. Running testing code
open another tab, and go to the testing code directory, run:
```bash
npx hardhat test
```
#### 3. Running coverage
in the file directory, run:
```bash
npx hardhat coverage
```
