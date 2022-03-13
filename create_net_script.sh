# default home is ~/.wasmd
# if you want to setup multiple apps on your local make sure to change this value
export NODE="--node //127.0.0.1:26657"
APP_HOME="~/.wasmd"
RPC="//localhost:26657"
CHAIN_ID="localnet"
# initialize wasmd configuration files
wasmd init localnet --chain-id ${CHAIN_ID} --home ${APP_HOME}

# add minimum gas prices config to app configuration file
sed -i -r 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucosm"/' ${APP_HOME}/config/app.toml

# Create main address
# --keyring-backend test is for testing purposes
# Change it to --keyring-backend file for secure usage.
export KEYRING="--keyring-backend test --keyring-dir $HOME/.wasmd_keys"
wasmd keys add main $KEYRING

# create validator address
wasmd keys add validator $KEYRING

# add your wallet addresses to genesis
wasmd add-genesis-account $(wasmd keys show -a main $KEYRING) 10000000000ucosm,10000000000stake --home ${APP_HOME}
wasmd add-genesis-account $(wasmd keys show -a validator $KEYRING) 10000000000ucosm,10000000000stake --home ${APP_HOME}

# add fred's address as validator's address
wasmd gentx validator 1000000000stake --home ${APP_HOME} --chain-id ${CHAIN_ID} $KEYRING

# collect gentxs to genesis
wasmd collect-gentxs --home ${APP_HOME}

# validate the genesis file
wasmd validate-genesis --home ${APP_HOME}

# run the node
wasmd start --home ${APP_HOME}
