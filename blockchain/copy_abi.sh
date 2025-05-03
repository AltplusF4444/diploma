#!/bin/sh

BLOG_JSON_PATH="/app/build/contracts/Blog.json"
SHARED_ABI_PATH="/shared/abi.json"

if [ -f "$BLOG_JSON_PATH" ]; then
  echo "Файл Blog.json найден. Копирую в /shared/abi.json..."
  cp "$BLOG_JSON_PATH" "$SHARED_ABI_PATH"
  echo "Копирование завершено."
  break
else
  echo "Ожидаю появления файла Blog.json..."
fi