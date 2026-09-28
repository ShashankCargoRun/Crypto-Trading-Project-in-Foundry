// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import {IAMMRouter} from "../interfaces/IAMMRouter.sol";
import {IPairFactory} from "../interfaces/IPairFactory.sol";
import {ITokenPair} from "../interfaces/ITokenPair.sol";
import {AMMLibrary} from "../libraries/AMMLibrary.sol";

contract AMMRouter is IAMMRouter {
    address public immutable factory;
    bytes32 private initCodeHash;

     constructor(address _factory) {
        factory = _factory;
        initCodeHash = IPairFactory(factory).INIT_CODE_PAIR_HASH();
    }