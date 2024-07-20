# Bring-your-own-gas Airnode requester

```sh
yarn
yarn test
```

[In Airnode request–response protocol (RRP) v0](https://github.com/api3dao/airnode/blob/master/packages/airnode-protocol/contracts/rrp/AirnodeRrpV0.sol), a [sponsor](https://docs.api3.org/reference/airnode/latest/concepts/sponsor.html) sponsors a [requester contract](https://docs.api3.org/reference/airnode/latest/concepts/requester.html), which means that the requester contract's requests will be fulfilled by the sponsor's [sponsor wallet](https://docs.api3.org/reference/airnode/latest/concepts/sponsor.html#sponsorwallet).
This implies that keeping the sponsor wallet topped up is the sponsor's responsibility.
Assuming the sponsor is operating the requester contract for profit (e.g., as a monetized dApp used by the public), the sponsor will want to reflect the gas cost to the user.
However, this is not a trivial problem, as the cost that needs to be reflected to the user depends on the gas price and the fulfillment gas cost, of which neither is deterministic.

In this prototype, the requester contract requires the user to make a gas cost contribution, but floats that to keep the sponsor wallet at a predetermined level.
This results in the users contributing more when the gas prices are high, less when the gas prices are low, and keeps the sponsor wallet topped up to act as a buffer against sudden gas price spikes.
This can be seen as users covering the fulfillment gas costs collectively, rather than each user covering their exact fulfillment gas cost.
