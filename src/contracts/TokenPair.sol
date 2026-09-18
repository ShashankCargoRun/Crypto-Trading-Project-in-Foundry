// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {ITokenPair} from "../interfaces/ITokenPair.sol";
import {IERC20} from "../interfaces/IERC20.sol";

contract TokenPair is ERC20, ReentrancyGuard, ITokenPair {
    address public factory;
    address public tokenA;
    address public tokenB;

    uint256 private reserveA;
     uint256 private reserveB;

    uint256 private blockTimestampLast;

    uint256 public constant MINIMUM_LIQUIDITY = 10 ** 3;

     bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));

      constructor() ERC20("LP Token", "LPT") {
        factory = msg.sender;
    }

 function initialize(address _tokenA, address _tokenB) external {
        require(msg.sender == factory, "Not Factory");
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function _setReserves(uint256 balance0, uint256 balance1) private {
        reserveA = balance0;
        reserveB = balance1;
        blockTimestampLast = block.timestamp;
        emit Sync(reserveA, reserveB);
    }

    function getReserves() public view returns (uint256 _reserveA, uint256 _reserveB, uint256 _blockLastTimestamp) {
        _reserveA = reserveA;
        _reserveB = reserveB;
        _blockLastTimestamp = blockTimestampLast;
    }

     function mint(address to) external nonReentrant returns (uint256 liquidity) {
        (uint256 _reserveA, uint256 _reserveB,) = getReserves();

        uint256 balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this));

      uint256 amountA = balanceA - _reserveA;
        uint256 amountB = balanceB - _reserveB;

         uint256 _totalSupply = totalSupply(); //total supply of the lp tokens