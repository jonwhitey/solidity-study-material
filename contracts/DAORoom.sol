//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/** @title DAO Room */
contract DAORoom {
    address payable public owner;

    uint256 public cost;

    enum Status {
        Vacant,
        Occupied
    }

    Status currentStatus;

    event Occupied(address _occupant);

    constructor() {
        owner = payable(msg.sender);
        cost = 1;
        currentStatus = Status.Vacant;
    }

    modifier onlyWhenVacant() {
        require(currentStatus == Status.Vacant, "Room is occupied");
        _;
    }

    /** @dev Rents a DAOroom to a user.
    * @dev Room status must be "vacant".
    * @dev User must have sufficient funds.
    * @dev User transfers value of cost to owner.
    * @dev Occupied event is emitted if rental is successful.
    * @notice does not change currentStatus to Occupied.  
    */
    function rent() external payable onlyWhenVacant {
        require(msg.value != cost, "Insufficient funds");
        owner.transfer(msg.value);
        emit Occupied(msg.sender);
    }
}
