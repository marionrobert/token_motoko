import React, { useState } from "react";
import {token} from "../../../declarations/token";
import { Principal } from "@dfinity/principal";


function Transfer() {

  const [account, setAccount] = useState("");
  const [amount, setAmount] = useState("");
  const [transferText, setTransferText] = useState("");
  const [isDisabled, setDisable] = useState(false);
  const [isHidden, setHidden] = useState(true);

  
  async function handleClick() {
    setHidden(true);
    setDisable(true)
    const accountId = Principal.fromText(account);
    const amountToTransfer = Number(amount);
    let result = await token.transfer(accountId, amountToTransfer);
    setTransferText(result);
    setHidden(false);
    setDisable(false);
    setAccount("");
    setAmount("");
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={account}
                onChange={(event) => setAccount(event.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(event) => setAmount(event.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button 
            id="btn-transfer" 
            onClick={handleClick}
            disabled={isDisabled}
            >
              Transfer
          </button>
          <p hidden={isHidden}>{transferText}</p>
        </p>
      </div>
    </div>
  );
}

export default Transfer;
