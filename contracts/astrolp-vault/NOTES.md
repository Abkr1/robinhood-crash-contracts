# astrolp-vault (unverified) — 0x58d2f2d46af20c357885d540a9c02fdd791ee1cf

ERC4626-style LP vault (token **ASTROLP**) on Robinhood Chain that holds the
bankroll for the crash game. **Source is not verified**, so this folder mirrors
everything recoverable on-chain.

- Explorer: https://robin.etherscan.io/address/0x58d2f2d46af20c357885d540a9c02fdd791ee1cf
- Creator: [`0x89CD80dc…447450b92`](https://robin.etherscan.io/address/0x89cd80dc1dce754d4358bacb9740933447450b92) (same deployer as the other three)
- Holds ~$82k (mostly USDG) at time of extraction
- Files: `runtime.hex` (deployed code), `creation.hex` (creation-tx input),
  `selectors.json`, `metadata.json`

## What it is (from selectors + activity)

57 of 60 selectors resolved via the openchain signature database (3 unknown,
omitted):

- ERC4626 surface: `asset()`, `totalAssets()`, `convertToAssets(uint256)`,
  `deposit(uint256,address)`, `mint(uint256,address)`,
  `withdraw(uint256,address,address)`, `redeem(uint256,address,address)`,
  previews, limits — plus `depositBetFrom(address,uint256)`,
  `withdrawBalance(uint256)`, `withdrawAllBalance()`
- Game linkage: `reserveRoundExposure(uint256)`, `releaseRoundExposure()`,
  `creditUsersAndSettle(address[],uint256[],uint256,uint256)`,
  `fundsInPlay()`, `reservedExposure()`, `getAvailableBankroll()`,
  `getTotalBankroll()`, player balances
- Ops: operator + pauser roles, `setFees(uint16,uint16,uint16)`,
  operator/dilution/withdrawal fee caps, `emergencyRecoverERC20`

## Reproducing this folder

```shell
cast code 0x58d2f2d46af20c357885d540a9c02fdd791ee1cf \
  --rpc-url https://rpc.mainnet.chain.robinhood.com > runtime.hex
cast tx 0x65b8206f7ed3b081e0631f1d0c824bdf449e01c9bc0244100dd56252bb9b4238 input \
  --rpc-url https://rpc.mainnet.chain.robinhood.com > creation.hex
```
