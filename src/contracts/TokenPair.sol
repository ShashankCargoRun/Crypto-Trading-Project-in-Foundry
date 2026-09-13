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
