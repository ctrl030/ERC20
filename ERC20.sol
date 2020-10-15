import "./Ownable.sol";
pragma solidity 0.5.12;

contract ERC20 is Ownable {

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    uint8 private _decimals;
    mapping (address => uint256) private _balances;
    
    mapping (address => mapping (address => uint)) private _allowances;
    
    //mapping (address => uint) private _valuesOfAllowances;

    event TransferSuccessfulEvent (address sender, uint amountTransferred, address recipient);
    
    event TransferFromSuccessfulEvent (address sender, uint amountTransferred, address recipient, address addressThatIsTransferring);

    constructor (string memory name, string memory symbol, uint totalSupply) public {
        _name = name;
        _symbol = symbol;
        _totalSupply = totalSupply;
        _decimals = 18;
    }

    function name() public view returns (string memory erc20Name) {
        return _name; 
    }

    function symbol() public view returns (string memory erc20Symbol) {
        return _symbol; 
    }

    function decimals() public view returns (uint8 erc20Decimals) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256 erc20TotalSupply) {
        return _totalSupply;
    }

    function balanceOf(address accountToShowBalanceOf) public view returns (uint256 balanceOfAddress) {
        return _balances[accountToShowBalanceOf];
    }

    function mint(address accountToBeMintedTo, uint256 amount) public onlyOwner{
        require (amount > 0);
        _balances[accountToBeMintedTo] += amount;
        _totalSupply += amount;
    }

    function transfer(address recipientAddress, uint amount) public returns (bool success) {

        require (amount <= _balances[msg.sender]);
        require (amount >= 0);
       
        uint balanceBeforeSending;
        uint balanceBeforeReceiving;
        
        balanceBeforeSending = _balances[msg.sender];
        balanceBeforeReceiving = _balances[recipientAddress]; 
        
        _balances[msg.sender] -= amount;
        _balances[recipientAddress] += amount;
        
        assert (_balances[msg.sender] == (balanceBeforeSending - amount));
        assert (_balances[recipientAddress] == (balanceBeforeReceiving + amount));
        
        if (_balances[msg.sender] != balanceBeforeSending - amount) {
            success = false;
        }
        else {
        success = true;
        }    
        
        if (success == false) {
        revert();
        }
        else {
            emit TransferSuccessfulEvent (msg.sender, amount, recipientAddress);
            return success;
        }
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require (_value <= _balances[msg.sender]); 
        _allowances[msg.sender][_spender] = _value;
        
        success = true;
        
        return success;
    }
    
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return _allowances[_owner][_spender];
    }
    
    function transferFrom (address senderAddress, address recipientAddress, uint amount) public returns (bool success) {
        
        require (amount <= _allowances[senderAddress][msg.sender]); 
        
        require (amount <= _balances[senderAddress]);
        require (amount >= 0);
       
        uint balanceBeforeSending;
        uint balanceBeforeReceiving;
        uint allowanceBeforeTransfer;
        
        balanceBeforeSending = _balances[senderAddress];
        balanceBeforeReceiving = _balances[recipientAddress]; 
        allowanceBeforeTransfer = _allowances[senderAddress][msg.sender];
        
        _balances[senderAddress] -= amount;
        _balances[recipientAddress] += amount;
        
        _allowances[senderAddress][msg.sender] -= amount;
        
        assert (_balances[senderAddress] == balanceBeforeSending - amount);
        assert (_balances[recipientAddress] == balanceBeforeReceiving + amount);
        assert (_allowances[senderAddress][msg.sender] == allowanceBeforeTransfer - amount);
        
        if (_balances[senderAddress] != balanceBeforeSending - amount) {
            success = false;
        }
        else {
            success = true;
        }    
        
        if (success == false) {
            revert();
        }
        else {
            emit TransferFromSuccessfulEvent (senderAddress, amount, recipientAddress, msg.sender);
            return success;
        }
        
    }
}
