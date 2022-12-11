// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./ReputationToken.sol";

/// @title Reputation Token Factory
/// @author Kurt
/// @dev Reputation Token Factory. Based on an updated verison of Giveth's MiniMeTokenFactory
contract ReputationTokenFactory {
    /// @notice Update the DApp by creating a new token with new functionalities
    ///  the msg.sender becomes the controller of this clone token
    /// @param _tokenName Name of the new token
    /// @param _decimalUnits Number of decimals of the new token
    /// @param _tokenSymbol Token Symbol for the new token
    /// @param _transfersEnabled If true, tokens will be able to be transferred
    /// @param _burnable If true, tokens will be able to be burned
    /// @param _controller The address of the controller of the token
    /// @return The address of the new token contract
    function createCloneToken(
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol,
        bool _transfersEnabled,
        bool _burnable,
        address _controller
    ) public returns (ReputationToken) {
        ReputationToken newToken = new ReputationToken(
            _tokenName,
            _tokenSymbol,
            _decimalUnits,
            _transfersEnabled,
            _burnable,
            _controller,
            address(this),
            payable(address(0)), // no parentToken
            0 // no parentSnapShotBlock
        );

        newToken.changeController(msg.sender);
        return newToken;
    }
}