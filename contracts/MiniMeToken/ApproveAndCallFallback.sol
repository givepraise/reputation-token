// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

abstract contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public virtual;
}