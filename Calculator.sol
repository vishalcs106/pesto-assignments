//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

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
    
    function mod(int a, int b) public pure returns (int) {
        require(b != 0, "Cannot take modulus by zero");
        return a % b;
    }

}