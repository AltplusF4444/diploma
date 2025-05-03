FROM node:18
WORKDIR /app
RUN npm install -g truffle ganache
COPY . .
CMD ["ganache", "--host", "0.0.0.0", "--port", "8545", "--mnemonic", "test test test test test test test test test test test junk"]