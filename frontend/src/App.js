import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { fetchAbi, fetchAddress } from "./utils/loadAbi";
import "./App.css"; // Импортируем стили

function App() {
  const [posts, setPosts] = useState([]);
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(false);
  const [contract, setContract] = useState(null);

  // Загрузка постов из контракта
  const loadPosts = async () => {
    if (!contract) return;

    try {
      setLoading(true);
      const postCount = await contract.getPostCount();
      const postsArray = [];
      console.log(postCount);
      for (let i = 0; i < postCount; i++) {
        const post = await contract.posts(i);
        postsArray.push(post);
      }
      setPosts(postsArray);
      console.log(postsArray);
      setLoading(false);
    } catch (error) {
      console.error("Ошибка при загрузке постов:", error);
      setLoading(false);
    }
  };

  // Подключение к MetaMask
  useEffect(() => {
    const connectMetaMask = async () => {
      if (window.ethereum) {
        try {
          await window.ethereum.request({ method: "eth_requestAccounts" });
          const provider = new ethers.providers.Web3Provider(window.ethereum);
          const signer = provider.getSigner();
          const address = await fetchAddress();
          const abi = await fetchAbi();
          const initializedContract = new ethers.Contract(address, abi, signer);
          setContract(initializedContract);
          await loadPosts();
        } catch (error) {
          console.error("Ошибка при подключении к MetaMask:", error);
        }
      } else {
        alert("Установите MetaMask!");
      }
    };

    connectMetaMask();
  }, []);

  // Создание нового поста
  const createPost = async () => {
    if (!contract) return;

    try {
      setLoading(true);
      const tx = await contract.createPost(content);
      await tx.wait();
      setContent("");
      await loadPosts();
    } catch (error) {
      console.error("Ошибка при создании поста:", error);
      setLoading(false);
    }
  };

  // Лайк поста
  const likePost = async (postId) => {
    if (!contract) return;

    try {
      setLoading(true);
      const tx = await contract.likePost(postId);
      await tx.wait();
      await loadPosts();
    } catch (error) {
      console.error("Ошибка при лайке поста:", error);
      setLoading(false);
    }
  };

  return (
    <div className="App">
      {/* Форма для создания нового поста */}
      <div className="form-container">
        <input
          type="text"
          value={content}
          onChange={(e) => setContent(e.target.value)}
          placeholder="Введите текст поста"
          disabled={loading || !contract}
        />
        <button
          onClick={createPost}
          disabled={loading || !content.trim() || !contract}
        >
          Создать пост
        </button>
      </div>

      {/* Список постов */}
      <div className="post-list">
        <h2>Посты:</h2>
        {loading ? (
          <p className="loading">Загрузка...</p>
        ) : posts.length === 0 ? (
          <p>Нет постов.</p>
        ) : (
          posts.map((post, index) => (
            <div key={index} className="post-item">
              <p>
                <strong>Автор:</strong> {post.author}
              </p>
              <p>
                <strong>Текст:</strong> {post.content}
              </p>
              <p>
                <strong>Лайки:</strong> {post.likes.toString()}
              </p>
              <button
                onClick={() => likePost(post.id.toNumber())}
                disabled={loading || !contract}
              >
                Лайк
              </button>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default App;