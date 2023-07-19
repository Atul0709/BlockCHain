// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract TestContract{
    bool public Success = true;
    int private myAge = 19;
    int public MyRank = 1;
    uint public MyCar = 2;
    string public MyName = "Atul Kumar";
    // address
    function GetSum(int a, int b) pure public returns (int) {
        int MySum = a + b;
        return MySum;
    }
}