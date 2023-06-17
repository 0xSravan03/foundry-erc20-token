-include .env

deploy:
	forge script script/DeployMyToken.s.sol:DeployMyToken --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
