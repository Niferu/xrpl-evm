-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

clean:; forge clean

update:; forge update

build:; forge build

test:; forge test

format:; forge fmt

anvil:; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS:= --rpc-url http://localhost:8545 --private-key $(LOCAL_PRIVATE_KEY) --broadcast

# Below doesnt support verification for chain 1449000
ifeq ($(findstring --network xrplt,$(ARGS)),--network xrplt)
	NETWORK_ARGS:= --rpc-url $(XRPL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(XRPL_API_KEY) -vvvv
endif

# Use below for deployment + verification
ifeq ($(findstring --network xrplevmt,$(ARGS)),--network xrplevmt)
	NETWORK_ARGS:= --rpc-url $(XRPL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --verifier blockscout --verifier-url $(XRPL_VERIFIER_URL)
endif

deployCounter:
	@forge script script/DeployCounter.s.sol:DeployCounter $(NETWORK_ARGS)

verifyCounter:
	@forge verify-contract $(COUNTER_ADDRESS) Counter --chain-id 1449000 --verifier blockscout --verifier-url=$(XRPL_VERIFIER_URL) --etherscan-api-key $(XRPL_API_KEY) --watch

call:
	@forge script scripts/solidity/Interactions.s.sol:CallProxy $(NETWORK_ARGS)
