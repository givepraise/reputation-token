import { HardhatUserConfig } from "hardhat/config";
import { config as dotenvConfig } from "dotenv";
import "@nomicfoundation/hardhat-toolbox";

dotenvConfig({ path: "./.env" });

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY || "";
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY || "";
const GNOSIS_PRIVATE_KEY = process.env.GNOSIS_PRIVATE_KEY || "";
const ETHEREUM_MAINNET_PRIVATE_KEY =
  process.env.ETHEREUM_MAINNET_PRIVATE_KEY || "";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";
const GNOSISSCAN_API_KEY = process.env.GNOSISSCAN_API_KEY || "";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
    },
    gnosis: {
      url: "https://rpc.gnosischain.com/",
      accounts: [GNOSIS_PRIVATE_KEY],
    },
    mainnet: {
      url: `https://eth-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [ETHEREUM_MAINNET_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      goerli: ETHERSCAN_API_KEY,
      gnosis: GNOSISSCAN_API_KEY,
      mainnet: ETHERSCAN_API_KEY,
    },
  },
};

export default config;
