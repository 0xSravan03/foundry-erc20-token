// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {Test} from "forge-std/Test.sol";

contract TestMyToken is Test {
    MyToken myToken;

    // Dummy users
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() public {
        DeployMyToken deployMyToken = new DeployMyToken();
        myToken = deployMyToken.run();

        // Funding newly created user addresses.
        vm.deal(user1, 10 ether);
        vm.deal(user2, 5 ether);
    }

    function testNameIsMyToken() public {
        assertEq(myToken.name(), "MyToken");
    }

    function testSymbolIsMTK() public {
        assertEq(myToken.symbol(), "MTK");
    }

    function testSenderBalanceShouldBe1000Ether() public {
        uint256 ownerBalance = myToken.balanceOf(msg.sender);
        assertEq(ownerBalance, 1000 ether);
    }

    function testTotalSupplyIs1000Ether() public {
        assertEq(myToken.totalSupply(), 1000 ether);
    }

    function testSenderShouldAbleToTransferToken() public {
        // If we don't use this here, inside myToken contract TestMyToken contract will be the msg.sender
        vm.prank(msg.sender); // Resetting the caller.
        myToken.transfer(user1, 100 ether);

        uint256 senderBalance = myToken.balanceOf(msg.sender);
        uint256 user1Balance = myToken.balanceOf(user1);

        assertEq(user1Balance, 100 ether);
        assertEq(senderBalance, 900 ether);
    }

    function testMsgSenderShouldAbleToSetAllowances() public {
        vm.prank(msg.sender);
        myToken.approve(user1, 200 ether);
        assertEq(myToken.allowance(msg.sender, user1), 200 ether);
    }

    function testShouldAbleToTransferAllowance() public {
        vm.prank(msg.sender);
        myToken.approve(user1, 100 ether); // alllowing user1 to spend 100 tokens

        vm.prank(user1);
        myToken.transferFrom(msg.sender, user2, 50 ether); // uuser1 transferring 50 tokens to user2

        assertEq(myToken.balanceOf(msg.sender), 950 ether); // msg.sender remaning balance since 50 token got transfered
        assertEq(myToken.balanceOf(user1), 0); // user1 is not getting any token since he is only spending on behalf of msg.sender
        assertEq(myToken.balanceOf(user2), 50 ether); // user2 get 50 tokens
        assertEq(myToken.allowance(msg.sender, user1), 50 ether); // since user1 spent 50 token, allowance reduced to 50 tokens from 100
    }

    function testShouldFailIfNotEnoughtAllowance() public {
        vm.prank(msg.sender);
        myToken.approve(user1, 100 ether);

        vm.expectRevert(bytes("ERC20: insufficient allowance"));
        vm.prank(user1);
        myToken.transferFrom(msg.sender, user2, 500 ether);
    }

    function testShouldFailIfTransferAmtExceedsFromBalance() public {
        vm.prank(msg.sender);
        myToken.approve(user1, 2000 ether); // approving token which is more than msg.sender balance

        vm.prank(user1);
        vm.expectRevert(bytes("ERC20: transfer amount exceeds balance"));
        myToken.transferFrom(msg.sender, user2, 2000 ether); // trying to transfer 2000 token from msg.sender whose balance is only 1000 token
    }
}