# Bring-your-own-gas Airnode client

In the Airnode protocol, a requester endorses a client contract, which means that that client contract's requests will be fulfilled by the requester's designated wallet.
This implies that keeping the designated wallet topped up is the requester's responsibility.
Assuming the requester is operating the client contract for profit (e.g., it's a monetized dApp used by the public), the requester will want to reflect the gas cost to the user.
However, this is not a trivial problem, as the cost that needs to be reflected to the user depends on the gas price and the fulfillment gas cost, of which both are not deterministic.

In this prototype, the client contract requires the user to make a gas cost contribution, but floats that to keep the designated wallet at a predetermined level.
This results in the users contributing more when the gas prices are high, less when the gas prices are low, and keeps the designated wallet topped up to act as a buffer against sudden gas price spikes.
This can be also seen as the users covering the fulfillment gas costs collectively, instead of each user covering their exact fulfillment gas cost.

Note that funding the designated wallet in batches will always be less costly.
This approach adds an additional ~25,000 gas cost per request.
However, it doesn't require the requester to estimate how much they should be charging the users per request for gas costs, which is why it may be desirable in chains where the gas cost is not significant.

In addition, this prototype is opinionated and the usage pattern needs to be optimized for the exact use case.
For example, the client contract can forward the entire contribution if `designatedWalletAddress.balance < designatedWalletBalanceTarget`, which would approximately halve the gas cost overhead.
However, this will probably not be perceived as being fair.
