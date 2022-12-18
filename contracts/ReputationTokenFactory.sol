// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ReputationToken.sol";

/// @title ReputationTokenFactory
/// @author Kurt
/// @notice This contract is used to create new ReputationToken contracts

contract ReputationTokenFactory {
    /// @notice Creates a new ReputationToken contract
    /// @param _name The name of the token
    /// @param _symbol The symbol of the token
    /// @param _decimals The number of decimals of the token
    /// @param _owner The owner of the token
    /// @param _transferable Whether the token is transferable
    /// @param _burnable Whether the token is burnable
    /// @return The address of the new token
    function create(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _owner,
        bool _transferable,
        bool _burnable
    ) external returns (address) {
        ReputationToken newToken = new ReputationToken(
            _name,
            _symbol,
            _decimals,
            _owner,
            _transferable,
            _burnable
        );
        emit TokenCreated(address(newToken), msg.sender);
        return address(newToken);
    }

    /// @notice Emitted when a new token is created
    event TokenCreated(address indexed token, address creator);
}
