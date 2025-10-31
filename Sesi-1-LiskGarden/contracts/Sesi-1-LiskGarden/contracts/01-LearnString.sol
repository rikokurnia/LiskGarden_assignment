// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnString {
    string public namaBunga;

    constructor(){
        namaBunga = 'rose';
    }

    function changeName(string memory _bungaBaru) public {
        namaBunga = _bungaBaru;
    }

}