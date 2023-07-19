// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FirstAdd{

    address public myAddress ;
     function setMyAddress(address updateAddress)  public {
         myAddress = updateAddress;
     }

    function getMyAddress()  public view returns (address) {
        return myAddress ;
     }
}