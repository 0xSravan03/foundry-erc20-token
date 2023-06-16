// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {Test} from "forge-std/Test.sol";

contract TestMyToken is Test {
    MyToken myToken;

    function setUp() public {
        DeployMyToken deployMyToken = new DeployMyToken();
        myToken = deployMyToken.run();
    }

    function testNameIsMyToken() public {
        assertEq(myToken.name(), "MyToken");
    }
}