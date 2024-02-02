// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test, console2} from "forge-std/Test.sol";
import {Robber} from "../src/Robber.sol";
import {EtherBank} from "../src/EtherBank.sol";

contract ReEntrancyRobberTest is Test {
    EtherBank victim;
    Robber attacker;

    function setUp() public {
        // Declaring our contracts
        victim = new EtherBank();
        attacker = new Robber(address(victim));
        // Labelling for test traces
        vm.label(address(victim), "victim_contract");
        vm.label(address(attacker), "attacker_contract");
        // Funding both parties
        vm.deal(address(attacker), 1 ether); // It is not necessary to fund the attacker as you could just send eth along, but still
        vm.deal(address(victim), 10 ether);
    }

    function test_exploit() public {
        console2.log(
            unicode"\n   📚📚 All things reentrancy: basic exploitation\n"
        );
        console2.log(
            "--------------------------------------------------------"
        );
        console2.log(
            unicode"| => Victim's balance 🙂 %s 🙂",
            address(victim).balance
        );
        console2.log(
            unicode"| => Attacker's balance 👀 %s 👀",
            address(attacker).balance
        );
        console2.log(
            "--------------------------------------------------------"
        );

        console2.log(unicode"\n\t💥💥💥💥 EXPLOITING... 💥💥💥💥\n");

        vm.expectRevert();

        attacker.steal();

        // Conditions to fullfill
        assertEq(address(victim).balance, 0);
        assertEq(address(attacker).balance, 11 ether);

        console2.log(
            "--------------------------------------------------------"
        );
        console2.log(
            unicode"| => Victim's balance ☠  %s ☠",
            address(victim).balance
        );
        console2.log(
            unicode"| => Attacker's balance 💯 %s 💯",
            address(attacker).balance
        );
        console2.log(
            "--------------------------------------------------------"
        );
    }
}
