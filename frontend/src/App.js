import { ethers } from "ethers";
import Blog from "./contracts/Blog.json";

function App() {
  const connectMetaMask = async () => {
    if (window.ethereum) {
      await window.ethereum.request({ method: 'eth_requestAccounts' });
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        "0x...",  // Адрес контракта
        Blog.abi,
        signer
      );
    }
  };

  return (
    <button onClick={connectMetaMask}>Connect MetaMask</button>
    // Добавьте компоненты для постов и лайков
  );
}

export default App;