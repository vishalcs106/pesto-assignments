import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import { useSmartAccountContext } from "./contexts/SmartAccountContext";
import { useWeb3AuthContext } from "./contexts/SocialLoginContext";
import Button from "./components/Button";
import Navigation from "./components/Navigation";
import Home from "./pages/Home";
import Marketplace from "./pages/Marketplace";
import CreateEvent from "./pages/CreateEvent";
import MyTickets from "./pages/MyTickets";
import SwapTokens from "./pages/SwapTokens";

const App: React.FC = () => {
  const classes = useStyles();
  const {
    address,
    loading: eoaLoading,
    userInfo,
    connect,
    disconnect,
    getUserInfo,
  } = useWeb3AuthContext();
  const {
    selectedAccount,
    loading: scwLoading,
    setSelectedAccount,
  } = useSmartAccountContext();

  console.log("address", address);

  let component;
  console.log("window.location.pathname", window.location.pathname);
  switch (window.location.pathname) {
    case "/":
      component = <Home />;
      break;

    case "/marketplace":
      component = <Marketplace />;
      break;

    case "/createEvent":
      component = <CreateEvent />;
      break;

    case "/myTickets":
      component = <MyTickets />;
      break;

    case "/swapToken":
      component = <SwapTokens />;
      break;

    default:
      break;
  }

  return (
    <div className={classes.bgCover}>
  
      <Navigation account={selectedAccount} setAccount={setSelectedAccount} />
      
      <main className={classes.container}>
        <Button
          onClickFunc={
            !address
              ? connect
              : () => {
                  setSelectedAccount(null);
                  disconnect();
                }
          }
          title={!address ? "Connect Wallet" : "Disconnect Wallet"}
        />

        {eoaLoading && <h2 style={{ margin: "20px" }}>Loading EOA...</h2>}

        {address && (
          <div style={{ margin: "20px" }}>
            <h2>EOA Address</h2>
            <p>{address.slice(0, 6) + "..." + address.slice(38, 42)}</p>
          </div>
        )}

        {selectedAccount && address && (
          <div>
            <h2>Smart Account Address</h2>
            <p>{selectedAccount.smartAccountAddress}</p>
          </div>
        )}
        
      </main>

      <div style={{justifyItems:"center"}}>{component}</div>  
      
    </div>
    
    
  );
};

const useStyles = makeStyles(() => ({
  bgCover: {
    backgroundColor: "#1a1e23",
    backgroundSize: "cover",
    width: "100%",
    minHeight: "100vh",
    color: "#fff",
    fontStyle: "italic",
  },
  container: {
    display: "flex",
    flexDirection: "column",
    width: "100%",
    minHeight: "8vh",
    height: "auto",
    padding: "20px 0px 20px 0px",
    alignItems: "end",
    justifyContent: "flex-start",
    flexWrap: "wrap",
    margin: "-80px -20px",
  },
  title: {
    marginBottom: 50,
    fontSize: 60,
    background: "linear-gradient(90deg, #12ECB8 -2.21%, #00B4ED 92.02%)",
    "-webkit-background-clip": "text",
    "-webkit-text-fill-color": "transparent",
  },
  animateBlink: {
    animation: "$bottom_up 2s linear infinite",
    "&:hover": {
      transform: "scale(1.2)",
    },
  },
  "@keyframes bottom_up": {
    "0%": {
      transform: "translateY(0px)",
    },
    "25%": {
      transform: "translateY(20px)",
    },
    "50%": {
      transform: "translateY(0px)",
    },
    "75%": {
      transform: "translateY(-20px)",
    },
    "100%": {
      transform: "translateY(0px)",
    },
  },
}));

export default App;
