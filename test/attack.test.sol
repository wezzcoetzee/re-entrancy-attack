// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test, console2} from "forge-std/Test.sol";
import {Robber} from "../src/Robber.sol";
import {EtherBank} from "../src/EtherBank.sol";

contract ReEntrancyRobberTest is Test {
    Robber private robber;
    EtherBank private etherBank;
    address private constant victim1 = address(11);
    address private constant victim2 = address(12);
    address private constant attacker = address(13);

    function setupVictim(address victim) private {
        deal(victim, 5 * 1e18);
        vm.startPrank(victim);
        etherBank.deposit{value: 1 * 1e18}();
        vm.stopPrank();
    }

    function setUp() public {
        etherBank = new EtherBank();
        robber = new Robber(address(etherBank));
        setupVictim(victim1);
        setupVictim(victim2);
    }

    function test() public {
        uint256 contractBalanceBefore = etherBank.getBalance();
        uint256 attackerBalBefore = attacker.balance;
        console2.log(
            "Balance of EtherBank Contract before attack is ",
            contractBalanceBefore
        );
        console2.log(
            "Balance of Attacker before attack is ",
            attackerBalBefore
        );

        vm.startPrank(attacker);
        robber.steal();
        vm.stopPrank();

        uint256 contractBalanceAfter = etherBank.getBalance();
        uint256 attackerBalAfter = attacker.balance;

        console2.log(
            "Balance of EtherBank Contract after attack is ",
            contractBalanceAfter
        );
        console2.log("Balance of Attacker after attack is ", attackerBalAfter);

        assertEq(contractBalanceAfter, 0, "Contract balance after attack");
        assertEq(
            attackerBalAfter,
            contractBalanceBefore + attackerBalBefore,
            "Balance of attacker"
        );
    }
}
