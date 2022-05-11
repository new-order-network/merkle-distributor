# Updateable @uniswap/merkle-distributor with SafeERC & test coverage
Forked from https://github.com/Uniswap/merkle-distributor


Added SafeERC capabilities for non-standard tokens
Added full test coverage / reports

*Update:* Added Ownable, and the ability of the owner to:
* Withdraw tokens
* Update the Merkle Root

 :exclamation:  Addresses can only claim one time even if they are airdropped more tokens by updating the merkle root   |
|-----------------------------------------|
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
