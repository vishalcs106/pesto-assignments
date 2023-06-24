
import React, { useState } from "react";
import SmartAccount from "@biconomy/smart-account";
import { ChainId } from '@biconomy/core-types'
import {SmartAccountContext} from '../contexts/SmartAccountContext'

const CreateEvent = () => {
    console.log("address CreateEvent ")
  const [formData, setFormData] = useState({
    name: "PestoDemoTicket",
    symbol: "PDT",
    supply: "100",
    mintPrice: "0.1",
    ticketUri: "",
    royaltyFee: "500",
    royaltyFeeAddress: "0x216F3F71Add8F2C3C9e19fA9b463b6031D5A14b9",
    sbtName: "PestoDemoSBT",
    sbtSymbol: "PDSBT",
    sbtTicketUri: "",
    eventName: "Pesto Demo Day",
    eventDesc: "The big day for Web3 Cohort Batch 1 folks",
    venue: "Zoom",
    startTimeStamp: "1687628460000",
    endTimeStamp: "1687639260000",
    baseTicketAddress: "",
    baseSbtAddress: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({ ...prevData, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();


    const balanceParams =
    {
      chainId: ChainId.POLYGON_MUMBAI, // chainId of your choice
      eoaAddress: "",
      tokenAddresses: [], 
    };


    const balFromSdk = await SmartAccountContext.Provider.getAlltokenBalances(balanceParams);
    console.info("getAlltokenBalances", balFromSdk);



    console.log(formData);
  };

  return (
    
    <form onSubmit={handleSubmit}>
        <p>{SmartAccountContext.value}</p>
      <label>
        Name:
        <br />
        <input
          type="text"
          name="name"
          value={formData.name}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Symbol:
        <br />
        <input
          type="text"
          name="symbol"
          value={formData.symbol}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Supply:
        <br />
        <input
          type="text"
          name="supply"
          value={formData.supply}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Mint Price:
        <br />
        <input
          type="text"
          name="mintPrice"
          value={formData.mintPrice}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Ticket URI:
        <br />
        <input
          type="text"
          name="ticketUri"
          value={formData.ticketUri}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Royalty Fee:
        <br />
        <input
          type="text"
          name="royaltyFee"
          value={formData.royaltyFee}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Royalty Fee Address:
        <br />
        <input
          type="text"
          name="royaltyFeeAddress"
          value={formData.royaltyFeeAddress}
          onChange={handleChange}
        />
      </label>

      <br />

      <label>
        Sbt Name:
        <br />
        <input
          type="text"
          name="sbtName"
          value={formData.sbtName}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Sbt Symbol:
        <br />
        <input
          type="text"
          name="sbtSymbol"
          value={formData.sbtSymbol}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Sbt Ticket URI:
        <br />
        <input
          type="text"
          name="ticketUri"
          value={formData.ticketUri}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Event Name:
        <br />
        <input
          type="text"
          name="eventName"
          value={formData.eventName}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Event Description:
        <br />
        <input
          type="text"
          name="eventDesc"
          value={formData.eventDesc}
          onChange={handleChange}
        />
      </label>

      <br />

      <label>
        Venue:
        <br />
        <input
          type="text"
          name="venue"
          value={formData.venue}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        Start Time:
        <br />
        <input
          type="text"
          name="startTime"
          value={formData.startTimeStamp}
          onChange={handleChange}
        />
      </label>
      <br />

      <label>
        End Time:
        <br />
        <input
          type="text"
          name="endTimestamp"
          value={formData.endTimeStamp}
          onChange={handleChange}
        />
      </label>
      <br />

      <button type="submit">Submit</button>
    </form>
  );
};

export default CreateEvent;
