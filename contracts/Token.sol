// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

abstract contract ERC20Token {
    function name() public virtual view returns (string memory);
    function symbol() public virtual view returns (string memory);
    function decimals() public virtual view returns (uint8);
    function totalSupply() public virtual view returns (uint256);
    function balanceOf(address _owner) public virtual view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Token is ERC20Token {

    string private _name;
    string private _symbol;
    uint8 private _decimal;
    uint256 private _totalSupply;
    address private _minter;
    mapping(address => uint256) private balances;

    constructor() {
        _name = "Revee Token";                              // setting my token name
        _symbol = "REV";                                    // setting my token symbol
        _decimal = 0;                                       // number of decimals used to get its user representation
        _totalSupply = 1000;                                // total number of my tokens that I initially want to mint
        _minter = msg.sender;                               // setting my deploying account as minter
        balances[_minter] = _totalSupply;                   // transferring my all tokens to the minter account
        emit Transfer(address(0), _minter, _totalSupply);   // recoring the transfer data by emitting an transfer event
    }

    function name() public override view returns (string memory) {
        return _name;
    }

    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    function decimals() public override view returns (uint8) {
        return _decimal;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(balances[_from] >= _value, "Not enough fund");
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        return transferFrom(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public override pure returns (bool success) {
        return true;
    }

    function allowance(address _owner, address _spender) public override pure returns (uint256 remaining) {
        return 0;
    }

    function mint(uint256 _amount) public returns(bool) {
        require(msg.sender == _minter, "Only minter can mint new tokens.");
        balances[_minter] += _amount;
        _totalSupply += _amount;
        emit Transfer(address(0), _minter, _amount);
        return true;
    }

    function burn(address _target, uint256 _amount) public returns(bool) {
        require(msg.sender == _minter, "Only minter can burn tokens.");
        if (balances[_target] >= _amount) {
            balances[_target] -= _amount;
            _totalSupply -= _amount;
        } else {
            _totalSupply -= balances[_target];
            balances[_target] = 0;
        }
        emit Transfer(_target, address(0), _amount);
        return true;
    }

}
