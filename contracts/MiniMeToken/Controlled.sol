// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract Controlled {
    /// @notice The address of the controller is the only address that can call
    ///  a function with this modifier
    modifier onlyController() {
        require(msg.sender == controller);
        _;
    }

    address public controller;

    constructor() {
        controller = msg.sender;
    }

    /// @notice Changes the controller of the contract
    /// @param _newController The new controller of the contract
    function changeController(address _newController) public onlyController {
        emit NewController(controller, _newController);
        controller = _newController;
    }

    event NewController(address oldController, address newController);
}
