FROM node:18

WORKDIR /app

RUN apt-get update && apt-get install -y jq
RUN npm install -g truffle ganache

COPY . .

RUN chmod +x copy_abi.sh

CMD ["ganache", "--host", "0.0.0.0", "--port", "8545", "--mnemonic", "test test test test test test test test test test test junk"]