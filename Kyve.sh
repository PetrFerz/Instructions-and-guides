#!/bin/bash


exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    source $HOME/.bash_profile
fi

function setup_Vars {
	if [ ! $MNEMONIC ]; then
		read -p "Enter MNEMONIC: " MNEMONIC
		echo 'export MNEMONIC='\"${MNEMONIC}\" >> $HOME/.bash_profile
	fi
	if [ ! $STAKE ]; then
		read -p "Enter How many coins do you want to stake?: " STAKE
		echo 'export STAKE='\"${STAKE}\" >> $HOME/.bash_profile
	fi
	. $HOME/.bash_profile
	sleep 1
}


function install_Deps {
	sudo apt-get update -y
	sudo apt-get upgrade -y
	sudo apt install unzip -y
}

function install_Software {
	mkdir -p $HOME/kyve/service
	cd $HOME/kyve
	wget -O kyve-evm-linux.zip https://github.com/KYVENetwork/evm/releases/download/v1.0.5/kyve-evm-linux.zip
	sleep 1s
	wget -O kyve-bitcoin-linux.zip https://github.com/kyve-org/bitcoin/releases/download/v0.0.0/kyve-bitcoin-linux.zip
	sleep 1s
	wget -O kyve-solana-linux.zip https://github.com/kyve-org/solana/releases/download/v0.0.1/kyve-solana-linux.zip
	sleep 1s
	wget -O kyve-zilliqa-linux.zip https://github.com/kyve-org/zilliqa/releases/download/v0.0.0/kyve-zilliqa-linux.zip
	sleep 1s
	wget -O kyve-stacks-linux.zip https://github.com/kyve-org/stacks/releases/download/v0.0.2/stacks-linux.zip
	sleep 1s
	wget -O kyve-celo-linux.zip https://github.com/kyve-org/celo/releases/download/v0.0.0/kyve-celo-linux.zip
	sleep 1s
	wget -O kyve-near-linux.zip https://github.com/kyve-org/near/releases/download/v0.0.1/kyve-near-linux.zip
	sleep 1s
	unzip -o "*.zip"
	chmod +x kyve-evm-linux kyve-solana-linux kyve-zilliqa-linux bitcoin-linux stacks-linux kyve-celo-linux kyve-near-linux
	mv kyve-evm-linux kyve-solana-linux kyve-zilliqa-linux bitcoin-linux stacks-linux kyve-near-linux kyve-celo-linux /usr/local/bin/
}

function install_Service {

echo "[Unit]
Description=Moonbeam
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-evm-linux) --poolId 0 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535
unzip -o "*.zip"
[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/moonbeam.service


echo "[Unit]
Description=Avalanche
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-evm-linux) --poolId 1 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/avalanche.service



echo "[Unit]
Description=Bitcoin
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-bitcoin-linux) --poolId 3 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/bitcoin.service



echo "[Unit]
Description=Solana
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-solana-linux) --poolId 4 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/solana.service


echo "[Unit]
Description=zilliqa
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-zilliqa-linux) --poolId 5 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/zilliqa.service


echo "[Unit]
Description=near
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-near-linux) --poolId 6 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/near.service


echo "[Unit]
Description=celo
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-celo-linux) --poolId 7 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/celo.service


echo "[Unit]
Description=evmos
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which kyve-evm-linux) --poolId 8 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/evmos.service



mv $HOME/kyve/service/* /etc/systemd/system/
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl daemon-reload
sudo systemctl restart systemd-journald

}

PS3='Please enter your choice (input your option number and press enter): '
options=("full installation on a new server" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "full installation on a new server")
            		sleep 1
			setup_Vars
			install_Deps
			install_Software
			install_Service
			break
            ;;
        "state_sync")
            		sleep 1
			state_sync
			break
            ;;
        "Quit")
            break
            ;;
        *) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done
