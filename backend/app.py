from flask import Flask, jsonify
from web3 import Web3
import json

app = Flask(__name__)

# Подключение к блокчейну
w3 = Web3(Web3.HTTPProvider('http://blockchain:8545'))

# Загрузка ABI
with open('/shared/abi.json', 'r') as f:
    contract_abi = json.load(f)["abi"]

# Адрес контракта
with open('/shared/contract_address.txt', 'r') as f:
    contract_address = f.read().strip()

# Создание экземпляра контракта
contract = w3.eth.contract(address=contract_address, abi=contract_abi)


@app.route('/posts', methods=['GET'])
def get_posts():
    posts = []
    for i in range(contract.functions.getPostCount().call()):
        post = contract.functions.posts(i).call()
        posts.append({
            'id': i,
            'author': post[0],
            'content': post[1],
            'timestamp': post[2],
            'likes': post[3]
        })
    return jsonify(posts)


@app.route('/abi', methods=['GET'])
def get_abi():
    with open('/shared/abi.json', 'r') as f:
        abi = json.load(f)
    print(jsonify(abi))
    return jsonify(abi)


@app.route('/address', methods=['GET'])
def get_address():
    with open('/shared/contract_address.txt', 'r') as f:
        address = f.read().strip()
    print(address)
    return address


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)