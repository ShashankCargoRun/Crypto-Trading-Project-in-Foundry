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

     modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "DEADLINE_EXPIRED");
        _;
    }

      // Fetch the reserves and pair address for a pair while respecting the token order
    function getReserves(
        address tokenA,
        address tokenB
    ) public view returns (uint256 reserveA, uint256 reserveB, address pair) {
        (address _tokenA,) = AMMLibrary.sortTokens(tokenA, tokenB);

        pair = AMMLibrary.pairFor(factory, tokenA, tokenB, initCodeHash);

         // // Check if pair exists before calling getReserves
        if (pair.code.length == 0) {
            return (0, 0, pair);
        }

        (uint256 _reserveA, uint256 _reserveB, ) = ITokenPair(pair)
            .getReserves();

        (reserveA, reserveB) = tokenA == _tokenA
            ? (_reserveA, _reserveB)
            : (_reserveB, _reserveA);
    }

     // Perform getAmountOut calculation along the pairs in the path
    //path [0xa,0xb] amountIn = 100 amounts = [100,200]
    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
        require(path.length >= 2, "INVALID_PATH");
        amounts = new uint256[](path.length);