//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/** @title ERC20 */
interface ERC20 {
    /** 
    * @dev returns totalSupply of the token.
    * @return _totalSupply The total token supply. 
    */
    function totalSupply() external view returns (uint256 _totalSupply);

    /** 
    * @dev returns an address' token balance 
    * @param _owner A public key associated with a token balance.
    * @return balance The address' token balance 
    */
    function balanceOf(address _owner) external view returns (uint256 balance);

    /** 
    * @dev Transfers tokens from one address to another. 
    * @param _to Address to send tokens to.
    * @param _value Amount of tokens to send.
    * @return success Boolean indicating a successful transfer.
    */
    function transfer(address _to, uint256 _value)
        external
        returns (bool success);

    /** 
    * @dev Transfers tokens from one address to another.
    * @param _from The debitted address.
    * @param _to The creditted address.
    * @param _value The amount of tokens transfered.
    * @return success A boolen value indicating a successful transfer.  
    */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    /** 
    * @dev Approves funds for transfer.
    * @param _spender Address of approver.
    * @param _value Value of approved funds.
    * @return success A boolean value indicating a successful transfer.
    */
    function approve(address _spender, uint256 _value)
        external
        returns (bool success);

    /** 
    * @dev Gives the amount of approved funds remaining.
    * @param _owner Address of owner of approved funders.
    * @param _spender Address of approved spender of funds.
    * @return remaining Number of tokens spender is allowed to spend on behalf of the owner.
    */
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining);

    /** 
    * @dev Event that indicates a token transfer has taken place.
    * @param  _from Debitted address.
    * @param _to Credditted address.
    * @param _value Amount of tokens transfered.
    */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    /** 
    * @dev Event that indicates an approval has occured
    * @param _owner Address of approvor
    * @param _spender Address of approved spender of funds
    * @param _value Amount of funds approved for spending 
    */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

/** @title My token */
contract MyToken is ERC20 {
    string public constant symbol = "MTK";
    string public constant name = "MyToken";
    uint256 public constant decimals = 18;

    uint256 private constant _totalSupply = 1000000000000000000000;

    mapping(address => uint256) private _balanceOf;

    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        _balanceOf[msg.sender] = _totalSupply;
    }

    /** 
    * @dev returns totalSupply of the token.
    * @return _totalSupply The total token supply. 
    */
    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev returns an address' token balance. 
    * @param _addr A public key associated with a token balance.
    * @return balance The address' token balance.
    */
    function balanceOf(address _addr) public view override returns (uint256) {
        return _balanceOf[_addr];
    }

    /** 
    * @dev Transfers tokens from one address to another. 
    * @param _to Address to send tokens to.
    * @param _value Amount of tokens to send.
    * @return success Boolean indicating a successful transfer.
    */
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool)
    {
        if (_value > 0 && _value <= balanceOf(msg.sender)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /**
    * @dev isContract Determines if an address is a EOA or a contract
    * @param _addr Address of the contract
    * @dev assembly retrieves he size of the code. EOA's have no code.
    * @return boolean indicating if the address is a contract
    */
    function isContract(address _addr) public view returns (bool) {
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;
    }

    /** 
    * @dev Transfers tokens from one address to another.
    * @param _from The debitted address.
    * @param _to The creditted address.
    * @param _value The amount of tokens transfered.
    * @return success A boolen value indicating a successful transfer.  
    */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool) {
        if (
            _allowances[_from][msg.sender] > 0 &&
            _value > 0 &&
            _allowances[_from][msg.sender] >= _value &&
            _value <= balanceOf(msg.sender) &&
            !isContract(_to)
        ) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }
    
    /** 
    * @dev Approves funds for transfer.
    * @param _spender Address of approver.
    * @param _value Value of approved funds.
    * @return success A boolean value indicating a successful transfer.
    */
    function approve(address _spender, uint256 _value)
        external
        override
        returns (bool)
    {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /** 
    * @dev Gives the amount of approved funds remaining.
    * @param _owner Address of owner of approved funders.
    * @param _spender Address of approved spender of funds.
    * @return remaining Number of tokens spender is allowed to spend on behalf of the owner.
    */
    function allowance(address _owner, address _spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[_owner][_spender];
    }
}
