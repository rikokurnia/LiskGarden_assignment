// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnBoolean{
    bool public isAlive;
    bool public isBlooming;

    constructor() {
        isAlive = true;
        isBlooming = false;
    }

    function changeStatus(bool _status) public {
        isAlive = _status;
    }

    function bloom() public {
        isBlooming = true;
    }

}