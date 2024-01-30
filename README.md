# Re-Entrency Attack

Re-entrency attacks happened when one smart contract calls another. Contract A calls contract B. Re-entracy exploit allows B to call back into A before A finishes execution.

## What is the exploit?

1. 

## Instructions

1. Install [Foundryup](https://book.getfoundry.sh/getting-started/installation).
2. Run the following command in your directory to install dependecies `forge install foundry-rs/forge-std`.
3. Run the following to build your contract `forge build`.
4. Run `forge test -vvv` to execute your tests.
