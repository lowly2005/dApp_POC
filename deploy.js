// Run local network docker run -d -p 8545:8545 trufflesuite/ganache-cli:latest
// Compile contract solcjs --bin --abi SignDoc.sol
const fs = require("fs");
const Web3 = require("web3");
const web3 = new Web3("http://localhost:7545");
const bytecode = fs
  .readFileSync("./build/SignDoc_old_sol_StoreDocument.bin")
  .toString();
const abi = JSON.parse(
  fs.readFileSync("./build/SignDoc_old_sol_StoreDocument.abi")
);


// Revoke contract 
(async function () {
  const ganacheAccounts = await web3.eth.getAccounts();
  const myWalletAddress = ganacheAccounts[0];
  console.log("[Ganache address]:", myWalletAddress);
  //https://web3js.readthedocs.io/en/v1.2.0/web3-eth-contract.html#eth-contract
  const myContract = new web3.eth.Contract(abi);
  myContract
    .deploy({
      data: bytecode
    })
    .send(
      {
        from: myWalletAddress,
        gas: 5000000,
      },
      function (error, transactionHash) {}
    )
    .on("error", function (error) {
      console.log("Error", error);
    })
    .on("confirmation", function (confirmationNumber, receipt) {
      console.log("FirstContract was successfully deployed!");
      console.log("[Confirmation Number]:", confirmationNumber);
      console.log("[Receipt]:", receipt);
    })
    .catch((err) => {
      console.error(err);
    });
})();
