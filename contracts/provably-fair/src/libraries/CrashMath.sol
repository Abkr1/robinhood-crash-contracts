// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library CrashMath {
    uint256 internal constant BASIS_POINTS = 10000;
    uint256 internal constant MIN_CRASH_BP = 10000; // 1.00x (instant crash)
    uint256 private constant E = 2 ** 52;

    // salt is the hash of the block containing closeBetting: unknowable by
    // anyone (operator included) before betting closes, so no party can know
    // or grind the crash point in advance
    function calculateCrashPoint(bytes32 seed, bytes32 salt, uint256 houseEdgeDivisor) internal pure returns (uint256) {
        bytes32 hash = keccak256(abi.encodePacked(seed, salt));

        // Extract 52 random bits from the hash (bits 204-255)
        uint256 h = uint256(hash) >> 204;

        // House edge: 1/houseEdgeDivisor chance of instant crash at 1.00x
        // Default 33 = ~3% house edge, configurable range 20-100 (5%-1%)
        if (h % houseEdgeDivisor == 0) {
            return BASIS_POINTS; // 1.00x = instant crash
        }

        // Original Bustabit formula: floor((100 * e - h) / (e - h)) / 100
        uint256 numerator = 100 * E - h;
        uint256 denominator = E - h;

        if (denominator == 0) {
            return type(uint256).max;
        }

        // Convert to basis points: (numerator / denominator / 100) * BASIS_POINTS
        uint256 crashBP = (numerator * BASIS_POINTS) / denominator / 100;

        if (crashBP < BASIS_POINTS) return BASIS_POINTS; // min 1.00x

        return crashBP;
    }

    function hashSeed(bytes32 seed) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(seed));
    }

    function withinTolerance(
        uint256 a,
        uint256 b,
        uint256 tolerance
    ) internal pure returns (bool) {
        if (a > b) {
            return (a - b) <= tolerance;
        }
        return (b - a) <= tolerance;
    }
}
