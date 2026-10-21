# crash-game (unverified) — 0xcc679b67ee1abc40c06cfe20ce4479effad9a407

Crash betting game on Robinhood Chain. **Source is not verified**, so this
folder mirrors everything recoverable on-chain.

- Explorer: https://robin.etherscan.io/address/0xcc679b67ee1abc40c06cfe20ce4479effad9a407
- Creator: [`0x89CD80dc…447450b92`](https://robin.etherscan.io/address/0x89cd80dc1dce754d4358bacb9740933447450b92) (same deployer as the other three)
- Files: `runtime.hex` (deployed code), `creation.hex` (creation-tx input),
  `selectors.json`, `metadata.json`

## What it is (from selectors + activity)

47 selectors, all resolved via the openchain signature database:

- Round lifecycle: `commitRound()`, `closeBetting(uint256)`,
  `finalizeRound(uint256,bytes32,bytes32,(address,uint256)[])`,
  `cancelRound(uint256,bytes32)`, `emergencyForceCancel(uint256)`,
  `cleanupStalledRoundBatch(uint256,uint256,bytes32)`,
  `claimRefundAfterTimeout(uint256)`
- Betting: `placeBet(uint256,uint256,uint256)`, `lockSalt(uint256)`,
  `initializeChain(bytes32,bytes32)`, `verifyRound(uint256)`
- Links to siblings: `provablyFair()` → `0x9e07…`, `accessController()` → `0x77b1…`
- Risk/ops: Kelly-criterion sizing (`setKellyParams`, `getKellyParams`),
  bet limits, house edge, pause, timeouts

## Reproducing this folder

```shell
cast code 0xcc679b67ee1abc40c06cfe20ce4479effad9a407 \
  --rpc-url https://rpc.mainnet.chain.robinhood.com > runtime.hex
cast tx 0xbf8789f5187d666d78a4b0d83135794ab3549bac2a7d13a2f2bf1db3c4755950 input \
  --rpc-url https://rpc.mainnet.chain.robinhood.com > creation.hex
```
