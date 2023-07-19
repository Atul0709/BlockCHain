// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Calculator {
   
    function add(int a, int b) public pure returns (int) {
        return a + b;
    } 
    function subtract(int a, int b) public pure returns (int) {
        return a - b;
    }
    function multiply(int a, int b) public pure returns (int) {
        return a * b;
    }
    function divide(int a, int b) public pure returns (int) {
        require(b != 0, "Cannot divide by zero");
        return a / b;
    }
}
