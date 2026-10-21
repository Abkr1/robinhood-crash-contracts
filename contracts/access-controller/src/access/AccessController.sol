// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessController is AccessControl {
    bytes32 public constant OWNER_ROLE = keccak256("OWNER");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER");

    constructor(address owner, address operator) {
        require(owner != address(0), "Invalid owner");
        require(operator != address(0), "Invalid operator");

        _grantRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(OWNER_ROLE, owner);
        _grantRole(OPERATOR_ROLE, operator);
        _grantRole(PAUSER_ROLE, owner);
    }

    function isOwner(address account) external view returns (bool) {
        return hasRole(OWNER_ROLE, account);
    }

    function isOperator(address account) external view returns (bool) {
        return hasRole(OPERATOR_ROLE, account);
    }

    function isPauser(address account) external view returns (bool) {
        return hasRole(PAUSER_ROLE, account);
    }

    function addOperator(address operator) external onlyRole(OWNER_ROLE) {
        require(operator != address(0), "Invalid operator");
        _grantRole(OPERATOR_ROLE, operator);
    }

    function removeOperator(address operator) external onlyRole(OWNER_ROLE) {
        _revokeRole(OPERATOR_ROLE, operator);
    }
}
