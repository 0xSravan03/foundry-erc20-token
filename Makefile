-include .env

anvil:; anvil

deploy:
	forge script script/DeployMyToken.s.sol:DeployMyToken --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

deploySepolia: 
	forge script script/DeployMyToken.s.sol:DeployMyToken --rpc-url $(SEPOLIA_RPC_URL) --private-key $(MY_PRIVATE_KEY) --broadcast
