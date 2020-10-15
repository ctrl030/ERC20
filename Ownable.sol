pragma solidity 0.5.12;

contract Ownable {
    
    address payable public owner;
    
    constructor () public {
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require (msg.sender == owner);
        _; // orders execution to continue, if this line is reached (i.e. the require above was passed) 
    }
    
}