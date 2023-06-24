import { ethers } from 'ethers'

const Navigation = ({ account, setAccount }) => {
  const connectHandler = async () => {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
    const account = ethers.utils.getAddress(accounts[0])
    setAccount(account)
  }

  return (
    <nav>
      <div className='nav__brand'>
        <a href="/"><h1>Tykto</h1></a>

        <ul className='nav__links'>
          <li><a href="/create">Create Event</a></li>
          <li><a href="/marketplace">Marketplace</a></li>
          <li><a href="/swapToken">Swap Tykto</a></li>
          <li><a href="/myTickets">My Tickets</a></li>
        </ul>
      </div>
    </nav>
  );
}

export default Navigation;