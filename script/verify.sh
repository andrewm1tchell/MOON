#!/bin/bash

# Load environment variables
source .env

# Verify MoonExtension
forge verify-contract ADDDRESS src/MoonExtension.sol:MoonExtension --chain-id 11155111 --constructor-args $(cast abi-encode "constructor(address)" ADDRESS) --etherscan-api-key $ETHERSCAN_API_KEY