// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ReputationToken.sol";
import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title ReputationTokenFactory
/// @author Kurt
/// @notice This contract is used to create new ReputationToken contracts

contract ReputationTokenFactory is OwnableUpgradeable {
    address public tokenImplementation;

    /// @notice constructor function which ensure deployer is set as owner
    function initialize(address _owner) external initializer {
        tokenImplementation = address(new ReputationToken());
        // initialize, so nobody else can do it
        ReputationToken(tokenImplementation).initialize(
            "ReputationTokenImplementation",
            "RTI",
            0, // no decimals
            address(0), // no owner/minter
            false, // not transferable
            false // not burnable
        );
        __Context_init_unchained();
        _transferOwnership(_owner);
    }

    function updateTokenImplementation(
        address _tokenImplementation
    ) external onlyOwner {
        tokenImplementation = _tokenImplementation;
        emit TokenImplementationUpdated(_tokenImplementation);
    }

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
        ReputationToken newToken = ReputationToken(
            ClonesUpgradeable.clone(tokenImplementation)
        );
        // ReputationToken newToken = new ReputationToken(
        //     _name,
        //     _symbol,
        //     _decimals,
        //     _owner,
        //     _transferable,
        //     _burnable
        // );
        emit TokenCreated(address(newToken), msg.sender);

        newToken.initialize(
            _name,
            _symbol,
            _decimals,
            _owner,
            _transferable,
            _burnable
        );

        return address(newToken);
    }

    /// @notice Emitted when a new token is created
    event TokenCreated(address indexed token, address creator);
    event TokenImplementationUpdated(address indexed tokenImplementation);
}
