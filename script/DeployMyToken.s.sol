// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MyToken} from "../src/MyToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployMyToken is Script {
    MyToken myToken;
    uint256 initialSupply = 1000 ether;

    function run() public returns (MyToken) {
        vm.startBroadcast();
        myToken = new MyToken(initialSupply);
        vm.stopBroadcast();

        return myToken;
    }
} 