// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LearnArray{
    string[] nama;


    function addNama1(string memory _namaOrang) public {
        nama.push(_namaOrang);
    }

    function addNama2(string memory _namaOrang) public {
        nama.push(_namaOrang);
    }

    function kurangNama() public {
        nama.pop();
    }

    function totalNama() public view returns (uint256) {
        return nama.length;
    }

    function getNamaid() public view returns (string[] memory) {
        return nama;
    }
}