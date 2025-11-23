// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; 
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenP2P is ERC20, ReentrancyGuard {
    using SafeERC20 for IERC20;

    event BuyToken(address indexed transferTo, uint256 amount);
    event SellToken(address indexed transferFrom, uint256 amount);

    IERC20 public immutable usdtToken; 
    uint256 public maxSupply;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint _maxSupply,
        address _usdtAddress
    ) ERC20(_name, _symbol) {
        require(_usdtAddress != address(0), "Invalid USDT address");
        usdtToken = IERC20(_usdtAddress);
        maxSupply = _maxSupply;
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function buyTokens(uint256 amount) external nonReentrant {
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded");

        usdtToken.safeTransferFrom(msg.sender, address(this), amount);

        _mint(msg.sender, amount);

        emit BuyToken(msg.sender, amount);
    }

    function sellTokens(uint amount) external nonReentrant {
        require(balanceOf(msg.sender) >= amount, "Your TokenP2P balance not enough");
        require(usdtToken.balanceOf(address(this)) >= amount, "Contract liquidity low");

        _burn(msg.sender, amount); 

        usdtToken.safeTransfer(msg.sender, amount);

        emit SellToken(msg.sender, amount);
    }
}