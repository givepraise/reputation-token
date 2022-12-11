// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./MiniMeToken/MiniMeToken.sol";

/// @title Reputation Token
/// @author Kurt
/// @dev Reputation Token. Based on an updated verison of Giveth's MiniMeToken
contract ReputationToken is MiniMeToken {
    bool public burnable;

    struct Recipient {
        address recipient;
        uint256 amount;
    }

    /// @notice Constructor to create a ReputationToken
    /// @param _tokenName Name of the new token
    /// @param _tokenSymbol Token Symbol for the new token
    /// @param _decimalUnits Number of decimals of the new token
    /// @param _transfersEnabled If true, tokens will be able to be transferred
    /// @param _burnable If true, tokens will be able to be burned
    /// @param _tokenFactory The address of the ReputationTokenFactory contract that
    ///  will create the Clone token contracts, the controller of the token, and
    ///  the initial distribution of the tokens
    /// @param _parentToken Address of the parent token, set to 0x0 if it is a
    ///  new token
    /// @param _parentSnapShotBlock Block of the parent token that will
    ///  determine the initial distribution of the clone token, set to 0 if it
    ///  is a new token
    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _decimalUnits,
        bool _transfersEnabled,
        bool _burnable,
        address _tokenFactory,
        address payable _parentToken,
        uint _parentSnapShotBlock
    )
        MiniMeToken(
            _tokenName,
            _tokenSymbol,
            _decimalUnits,
            _transfersEnabled,
            _tokenFactory,
            _parentToken,
            _parentSnapShotBlock
        )
    {
        burnable = _burnable;
    }

    /// @notice Mint tokens to a list of recipients
    /// @param _recipients Array of Recipient structs
    function mintMany(Recipient[] memory _recipients) external onlyController {
      uint256 length = _recipients.length;
        for (uint256 i = 0; i < length;) {
            _mint(_recipients[i].recipient, _recipients[i].amount);
            unchecked {
                i++;
            }
        }
    }

    /// @notice Burn tokens from an account
    /// @param _account Address of the account to burn tokens from
    /// @param _amount Amount of tokens to burn
    /// @return True if successful
    function burn(address _account, uint256 _amount) external override onlyController returns(bool) {
        require(burnable, "ReputationToken: not burnable");
        return _burn(_account, _amount);
    }

    /// @notice Enable or disable transfers
    /// @param _transferEnabled True if transfers should be enabled
    function enableTransfers(bool _transferEnabled) external override onlyController {
        transfersEnabled = _transferEnabled;  
        emit EnableTransfers(_transferEnabled);
    }

    // Events
    event EnableTransfers(bool _transferEnabled);
}
