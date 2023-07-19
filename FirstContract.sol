// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FirstContract {
    string public number_1 = "This is a string";
    int public result;

    function First_function(int num1, int num2) public {
        result = num1 + num2;
    }
}

