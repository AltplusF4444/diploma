const abiPath = "/api/abi";
const addressPath = "/api/address";

export async function fetchAbi() {
  const response = await fetch(abiPath);
  const data = await response.json();
  return data.abi;
}

export async function fetchAddress() {
  const response = await fetch(addressPath);
  const address = await response.text();
  return address.trim();
}