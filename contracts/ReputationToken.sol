// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {OwnableUpgradeable as Ownable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20Upgradeable as ERC20} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import {ERC20VotesUpgradeable as ERC20Votes} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


/// @title ReputationToken
/// @author Kurt
/// @notice This contract is a ERC20Votes token with additional functionality.
/// The Owner can burn tokens, if burnable is true and mint tokens. The Owner can also set whether the token is transferable or not.
contract ReputationToken is ERC20, ERC20Votes, Ownable {
    bool public transferable;
    bool public burnable;
    uint8 dec;

    struct MintData {
        address account;
        uint256 amount;
    }

    /// @notice Initializer for the ReputationToken contract
    /// @param _name The name of the token
    /// @param _symbol The symbol of the token
    /// @param _decimals The number of decimals of the token
    /// @param _owner The owner of the token
    /// @param _transferable Whether the token is transferable
    /// @param _burnable Whether the token is burnable

    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _owner,
        bool _transferable,
        bool _burnable
    ) public initializer {
        __ERC20_init(_name, _symbol);
        __ERC20Permit_init(_name);
        __ERC20Votes_init();
        __Ownable_init();
        transferable = _transferable;
        burnable = _burnable;
        dec = _decimals;
        _transferOwnership(_owner);
    }

    /// @notice Burns tokens from the specified account.
    /// Can only be called by owner when burnable is set to true/
    /// @param _account The account to burn tokens from
    /// @param _amount The _amount of tokens to burn
    function burn(address _account, uint256 _amount) external onlyOwner {
        if (!burnable) revert NotBurnable();
        if (balanceOf(_account) < _amount) revert NotEnoughTokens();
        if (_account == address(0)) revert ZeroAddress();

        _burn(_account, _amount);
    }

    /// @notice Mints tokens to a specified account.
    /// Can only be called by owner.
    /// @param _account The account to mint tokens to
    /// @param _amount The _amount of tokens to mint
    function mint(address _account, uint256 _amount) external onlyOwner {
        _mint(_account, _amount);
    }

    /// @notice Mints tokens to multiple accounts.
    /// Can only be called by owner.
    /// @param _data The data to mint tokens to multiple accounts
    function mintMany(MintData[] memory _data) external onlyOwner {
        for (uint256 i = 0; i < _data.length; ) {
            _mint(_data[i].account, _data[i].amount);
            unchecked {
                i++;
            }
        }
    }

    /// @notice Sets whether the token is burnable or not.
    function setTransferable(bool _flag) external onlyOwner {
        transferable = _flag;
        emit TransferableSet(_flag);
    }

    /// @notice Returns the number of decimals of the token
    /// @return The number of decimals of the token
    function decimals() public view override(ERC20) returns (uint8) {
        return dec;
    }

    /// @notice overrides the _transfer function and checks if the token is transferable
    /// @param _from The address to transfer from
    /// @param _to The address to transfer to
    /// @param _amount The _amount of tokens to transfer
    function _transfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal override {
        if (!transferable) revert NotTransferable();
        super._transfer(_from, _to, _amount);
    }

    /// @notice overrides the _beforeTokenTransfer function
    /// @param from The address to transfer from
    /// @param to The address to transfer to
    /// @param _amount The _amount of tokens to transfer
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 _amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, _amount);
    }

    /// @notice overrides the _mint function
    /// @param to The address to mint tokens to
    /// @param _amount The _amount of tokens to mint
    function _mint(
        address to,
        uint256 _amount
    ) internal override(ERC20, ERC20Votes) {
        super._mint(to, _amount);
    }

    /// @notice overrides the _burn function
    /// @param _account The address to burn tokens from
    /// @param _amount The _amount of tokens to burn
    function _burn(
        address _account,
        uint256 _amount
    ) internal override(ERC20, ERC20Votes) {
        super._burn(_account, _amount);
    }

    /// @notice emitted when transferable is set
    event TransferableSet(bool flag);

    error NotBurnable();
    error NotEnoughTokens();
    error ZeroAddress();
    error NotTransferable();
}
