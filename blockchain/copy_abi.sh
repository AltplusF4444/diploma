#!/bin/sh

BLOG_JSON_PATH="/app/build/contracts/Blog.json"
SHARED_ABI_PATH="/shared/abi.json"
SHARED_ADDRESS_PATH="/shared/contract_address.txt"

if [ -f "$BLOG_JSON_PATH" ]; then
  echo "Файл Blog.json найден. Копирую в /shared/abi.json..."
  cp "$BLOG_JSON_PATH" "$SHARED_ABI_PATH"
  echo "Копирование завершено."

  > $SHARED_ADDRESS_PATH

  NETWORK_IDS=$(jq -r '.networks | keys[]' "$BLOG_JSON_PATH")
  LAST_NETWORK_ID=$(echo "$NETWORK_IDS" | tail -n 1)
  CONTRACT_ADDRESS=$(jq -r ".networks[\"$LAST_NETWORK_ID\"].address" "$BLOG_JSON_PATH")
  echo "$CONTRACT_ADDRESS" >> $SHARED_ADDRESS_PATH
else
  echo "Ожидаю появления файла Blog.json..."
fi