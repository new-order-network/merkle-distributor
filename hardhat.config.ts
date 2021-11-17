import { task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
//import { HardhatUserConfig } from "hardhat/types";
import '@typechain/hardhat'
import 'solidity-coverage'


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (args, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

export default {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      hardfork: 'istanbul',
      accounts:{
        mnemonic: 'horn horn horn horn horn horn horn horn horn horn horn horn',
      },
      blockGasLimit: 9999999,
    },
    // development:{
    //   host: '127.0.0.1',
    //   port: 8545,
    //   network_id: '*' // match any netwrok id
    // },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  settings: {
    outputSelection: {
      "*": {
        "*": [
          "evm.bytecode.object",
          "evm.deployedBytecode.object",
          "abi",
          "evm.bytecode.sourceMap",
          "evm.deployedBytecode.sourceMap",
          "metadata"
        ],
        "": ["ast"]
      }
    },
    evmVersion: "istanbul",
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  mocha: {
    grep: "@skip-on-coverage", // Find everything with this tag
    invert: true,
    timeout: 20000
  }
};