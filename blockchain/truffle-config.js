const path = require("path");

module.exports = {
  contracts_build_directory: path.join(__dirname, "build/contracts"),
  networks: {
    ganache: {
      host: "blockchain", // Имя сервиса blockchain в docker-compose.yml
      port: 8545,
      network_id: "*", // Подключаемся к любой сети
    },
  },
  compilers: {
    solc: {
      version: "0.8.21", // Версия Solidity
    },
  },
};