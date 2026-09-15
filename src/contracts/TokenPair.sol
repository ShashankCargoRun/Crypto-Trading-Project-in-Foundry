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
