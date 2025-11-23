// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TokenP2P} from "../src/TokenP2P.sol";
import {MockUSDT} from "../src/mocks/mockUSDT.sol";

contract TokenP2PTest is Test {
    TokenP2P public token;
    MockUSDT public usdt;
    address public owner = address(0x1);
    address public user = address(0x2);

    uint256 public constant MAX_SUPPLY = 1000000 * 10**6; // 1M tokens with 6 decimals
    uint256 public constant BUY_AMOUNT = 1000 * 10**6;   // 1000 tokens

    function setUp() public {
        usdt = new MockUSDT();
        token = new TokenP2P("TestToken", "TEST", MAX_SUPPLY, address(usdt));

        usdt.mint(user, BUY_AMOUNT);

        vm.prank(user);
        usdt.approve(address(token), type(uint256).max);
    }

    function testConstructor() public {
        assertEq(token.name(), "TestToken");
        assertEq(token.symbol(), "TEST");
        assertEq(token.decimals(), 6);
        assertEq(token.maxSupply(), MAX_SUPPLY);
        assertEq(address(token.usdtToken()), address(usdt));
        assertEq(token.totalSupply(), 0);
    }

    function testBuyTokens() public {
        uint256 userBalanceBefore = token.balanceOf(user);
        uint256 totalSupplyBefore = token.totalSupply();
        uint256 usdtBalanceBefore = usdt.balanceOf(user);
        uint256 contractUsdtBalanceBefore = usdt.balanceOf(address(token));

        vm.prank(user);
        token.buyTokens(BUY_AMOUNT);

        assertEq(token.balanceOf(user), userBalanceBefore + BUY_AMOUNT);
        assertEq(token.totalSupply(), totalSupplyBefore + BUY_AMOUNT);
        assertEq(usdt.balanceOf(user), usdtBalanceBefore - BUY_AMOUNT);
        assertEq(usdt.balanceOf(address(token)), contractUsdtBalanceBefore + BUY_AMOUNT);
    }

    function testBuyTokensExceedsMaxSupply() public {
        vm.prank(user);
        vm.expectRevert("Max supply exceeded");
        token.buyTokens(MAX_SUPPLY + 1);
    }

    function testSellTokens() public {
        vm.startPrank(user);
        token.buyTokens(BUY_AMOUNT);

        uint256 userBalanceAfter = token.balanceOf(user);
        assertTrue(userBalanceAfter == BUY_AMOUNT, "User should have tokens after buying");

        uint256 sellAmount = BUY_AMOUNT;
        token.sellTokens(sellAmount);

        vm.stopPrank();

        assertEq(token.balanceOf(user), 0);
        assertEq(token.totalSupply(), 0);
        assertEq(usdt.balanceOf(user), BUY_AMOUNT);
    }

    function testSellTokensInsufficientBalance() public {
        vm.prank(user);
        vm.expectRevert("Your TokenP2P balance not enough");
        token.sellTokens(1);
    }

    function testSellTokensInsufficientLiquidity() public {
        vm.startPrank(user); 
        token.buyTokens(BUY_AMOUNT);

        vm.mockCall(
            address(usdt),
            abi.encodeWithSignature("balanceOf(address)"),
            abi.encode(uint256(0))
        );

        vm.expectRevert("Contract liquidity low");
        token.sellTokens(100);

        vm.stopPrank();
    }

    function testConstructorInvalidUSDTAddress() public {
        vm.expectRevert("Invalid USDT address");
        new TokenP2P("TestToken", "TEST", MAX_SUPPLY, address(0));
    }

    function testMultipleBuysAndSells() public {
        uint256 buyAmount1 = 1000 * 10**6;
        uint256 buyAmount2 = 2000 * 10**6;

        usdt.mint(user, buyAmount2);

        //buy
        vm.prank(user);
        token.buyTokens(buyAmount1);

        vm.prank(user);
        token.buyTokens(buyAmount2);

        assertEq(token.balanceOf(user), buyAmount1 + buyAmount2);

        //sell
        vm.prank(user);
        token.sellTokens(buyAmount1);

        assertEq(token.balanceOf(user), buyAmount2);
    }
}