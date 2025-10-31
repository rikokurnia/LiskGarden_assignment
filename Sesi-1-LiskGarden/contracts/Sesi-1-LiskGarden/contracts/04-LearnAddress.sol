// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract LearnAddress {
    address public owner;
    address public gardener;

    constructor() {
        owner = msg.sender;
    } 

    function setGardener(address _gardener) public {
        gardener  = _gardener;
    }

}