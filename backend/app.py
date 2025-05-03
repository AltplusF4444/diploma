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
contract_address = '0x5FbDB2315678afecb367f032d93F642f64180aa3'

# Создание экземпляра контракта
contract = w3.eth.contract(address=contract_address, abi=contract_abi)
print(contract_abi)

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)