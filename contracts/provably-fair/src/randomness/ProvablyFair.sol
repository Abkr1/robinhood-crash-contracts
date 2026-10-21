// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {CrashMath} from "../libraries/CrashMath.sol";

contract ProvablyFair {
    function calculateCrashPoint(bytes32 seed, bytes32 salt, uint256 houseEdgeDivisor) external pure returns (uint256) {
        return CrashMath.calculateCrashPoint(seed, salt, houseEdgeDivisor);
    }

    function hashSeed(bytes32 seed) external pure returns (bytes32) {
        return CrashMath.hashSeed(seed);
    }

    function verifyRound(
        bytes32 seedHash,
        bytes32 seed,
        bytes32 salt,
        uint256 claimedCrashPointBP,
        uint256 houseEdgeDivisor
    ) external pure returns (bool valid, string memory reason) {
        if (CrashMath.hashSeed(seed) != seedHash) {
            return (false, "Seed does not match committed hash");
        }

        uint256 calculatedCrash = CrashMath.calculateCrashPoint(seed, salt, houseEdgeDivisor);

        if (!CrashMath.withinTolerance(calculatedCrash, claimedCrashPointBP, 1)) {
            return (false, "Crash point does not match calculation");
        }

        return (true, "Round is provably fair");
    }

    function verifySeedHash(bytes32 seed, bytes32 expectedHash) external pure returns (bool) {
        return CrashMath.hashSeed(seed) == expectedHash;
    }

    function getMinCrashBP() external pure returns (uint256) {
        return CrashMath.MIN_CRASH_BP;
    }
}
