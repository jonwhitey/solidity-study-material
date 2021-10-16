//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;


/** @title Address Book */
contract AddressBook {

    struct Record {
        string name;
        address addr;
        string note;
    }

    mapping(address => Record[]) private _aBook;

    /** @dev Calculates the length of a string.
    * @param _str string Length to be caluclated.
    * @return uint The length of _str. 
    */
    function getStringLength(string memory _str) public pure returns (uint256) {
        bytes memory bts = bytes(_str);
        return bts.length;
    }

    /** @dev Adds a Record Struct to the _aBook address => Record mapping
    * @param _name Name associated with the address
    * @param _addr Public key associated with the name
    * @param _note Additional information user would like to save
    */
    function addAddress(
        string memory _name,
        address _addr,
        string memory _note
    ) public {
        require(getStringLength(_name) >= 1, "Name can not be empty");
        Record memory newRecord = Record(_name, _addr, _note);
        _aBook[msg.sender].push(newRecord);
    }

    /** @dev Returns a users Record fromt the _aBook */
    function getAddrBook() public view returns (Record[] memory) {
        return _aBook[msg.sender];
    }
}
