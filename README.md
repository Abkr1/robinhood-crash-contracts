# Robinhood crash-game contracts

Four contracts on **Robinhood Chain** (chain ID `4663`, Arbitrum Orbit L2, ETH gas) that together form a provably-fair crash betting game plus its LP vault.

| # | Address | Folder | Status |
|---|---------|--------|--------|
| 1 | [`0xcc679b67ee1abc40c06cfe20ce4479effad9a407`](https://robin.etherscan.io/address/0xcc679b67ee1abc40c06cfe20ce4479effad9a407) | [`contracts/crash-game`](contracts/crash-game) | Unverified — bytecode + selectors |
| 2 | [`0x58d2f2d46af20c357885d540a9c02fdd791ee1cf`](https://robin.etherscan.io/address/0x58d2f2d46af20c357885d540a9c02fdd791ee1cf) | [`contracts/astrolp-vault`](contracts/astrolp-vault) | Unverified — bytecode + selectors (ASTROLP token) |
| 3 | [`0x9e07adc6eea2ee5c781417f277634104210ba43f`](https://robin.etherscan.io/address/0x9e07adc6eea2ee5c781417f277634104210ba43f) | [`contracts/provably-fair`](contracts/provably-fair) | Verified `ProvablyFair` — full source, builds |
| 4 | [`0x77b12caa89f78be0702e4bc9613faeaac66e70fb`](https://robin.etherscan.io/address/0x77b12caa89f78be0702e4bc9613faeaac66e70fb) | [`contracts/access-controller`](contracts/access-controller) | Verified `AccessController` — full source, builds |

How they fit together (from on-chain selectors): the crash game (`placeBet`, `closeBetting`, `commitRound`, `finalizeRound`) reads `provablyFair()` and `accessController()` — i.e. contracts 3 and 4. The vault (ERC4626-style: `deposit`, `redeem`, `totalAssets`, plus `reserveRoundExposure` / `creditUsersAndSettle`) holds the bankroll the game plays against.

Public RPC: `https://rpc.mainnet.chain.robinhood.com`

## Layout

```
robinhood-crash-contracts/
  contracts/
    crash-game/         # 0xcc67… (unverified)
      runtime.hex       # deployed bytecode (21,499 bytes, via eth_getCode)
      creation.hex      # creation-tx input (init code + args)
      selectors.json    # 47 function selectors, resolved via openchain
      metadata.json     # address, codehash, creator, links
      NOTES.md
    astrolp-vault/      # 0x58d2… (unverified, ASTROLP token)
      runtime.hex       # 15,780 bytes
      creation.hex
      selectors.json    # 57 function selectors
      metadata.json
      NOTES.md
    provably-fair/      # 0x9e07… (verified, solc 0.8.24, 10000 runs, cancun)
      src/randomness/ProvablyFair.sol
      src/libraries/CrashMath.sol
      abi.json  foundry.toml
    access-controller/  # 0x77b1… (verified, solc 0.8.24, 10000 runs, cancun)
      src/access/AccessController.sol
      lib/openzeppelin-contracts/… (vendored OZ v5)
      abi.json  foundry.toml  remappings.txt
```

## Build (verified contracts)

Requires [Foundry](https://book.getfoundry.sh/). Each verified contract is its own
Foundry project (different dependency sets):

```shell
cd contracts/provably-fair && forge build
cd ../access-controller && forge build
```

Both compile clean with solc 0.8.24 (only style lints).

## Unverified contracts

Contracts 1 and 2 are **not verified** on RobinScan, so there is no source to
mirror. Each folder contains the deployed bytecode, the creation bytecode,
`selectors.json` (dispatcher selectors resolved to signatures where possible)
and `metadata.json`. Three vault selectors had no openchain entry and are
omitted — see `selectors.json` + `NOTES.md` in each folder.

## License

- `provably-fair` sources: `SPDX-License-Identifier: MIT` (preserved per file).
- `access-controller` sources: MIT / OpenZeppelin (preserved per file).
- No license grant is made by this mirror for any of the four contracts.
