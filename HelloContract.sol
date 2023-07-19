// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloContract{
    string public hello = "hello world";
    
    string public result;
    function update(string memory updatedstring)  public {
        result  = updatedstring;
     }
}
