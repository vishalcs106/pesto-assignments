pragma solidity ^0.8.4;

contract OwnerControlGame{
    address owner;
    uint256 contractValue;
    uint256 public previousOwnerDeposits;
    uint256 public minThresholdETH = 0.0001 ether;
    
    struct User{
        address payable userAddress;
        uint256 userId;
        bool isRegistered;
        uint256 balance;
    }

    mapping(address => User) public userRecords;

    event OwnerChanged(address indexed oldOwner, address indexed newOwner, uint256 indexed timestamp);
    event NewUserRegistered(address indexed _user, uint256 indexed _userId, uint256 indexed timestamp);
    event BalanceWithdrawn(address indexed _user, uint256 balance);

    modifier checkUser(address _userAddress){
        require(_userAddress == msg.sender, "Impersonating user - Bad call");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Caller is not Owner");
        _;
    }

    constructor() payable{
        // Want to check if ETHER provided is 1 or more than - If not, revert
        require(msg.value >= minThresholdETH, "Invalid Amount Passed");
        // If success - make the deployer as the owner.
        owner = msg.sender;
        // If success - initialize contract's value as whatever value is passed by deployer
        contractValue = msg.value;
        previousOwnerDeposits = msg.value;
    }

    function getOwner() external view returns(address){
        return owner;
    }

    function getContractValue() external view returns(uint256){
        return contractValue;
    }

    function setContractValue() external onlyOwner() payable{
        require(msg.value > previousOwnerDeposits, "Invalid amount");
        contractValue += msg.value;
        userRecords[msg.sender].balance += msg.value;
    }

    function register(address payable _userAddress, uint256 _id) external checkUser(_userAddress){
        User memory newUser;

        newUser.userAddress = _userAddress;
        newUser.userId = _id;
        newUser.isRegistered = true;
        userRecords[msg.sender] = newUser;

        emit NewUserRegistered(msg.sender, _id, block.timestamp);
    }

    function makeMeAdmin() external payable{
        User memory user = userRecords[msg.sender];

        require(user.isRegistered, "User is not registered");
        require(msg.value > previousOwnerDeposits,"Less deposit than prev owner");

        address oldOwner = owner;
        owner = msg.sender;
        previousOwnerDeposits = msg.value;
        contractValue += msg.value;
        userRecords[msg.sender].balance += msg.value;
        emit OwnerChanged(oldOwner, msg.sender, block.timestamp);
    }

    function withdraw() external payable{
        require(msg.sender != owner, "Owner can't withdraw funds");
        require(userRecords[msg.sender].isRegistered, "User Not registered");
        require(userRecords[msg.sender].balance > 0, "Was not a owner prevoiusly");
        require(address(this).balance > userRecords[msg.sender].balance, "Insufficient Balance");
        uint256 balance = userRecords[msg.sender].balance;
        contractValue -= balance;
        userRecords[msg.sender].isRegistered = false;
        userRecords[msg.sender].balance = 0;
         payable(msg.sender).transfer(balance);
        emit BalanceWithdrawn(msg.sender, balance);
    }

}
