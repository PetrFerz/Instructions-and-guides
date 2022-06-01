# Kyve node ( это не копипаст )
kyve1zzjf4f0lvcnguf9lfzryje4zcqrkre77jpj87y

Нода Kyve очень не требовательна в плане железа, поэтому подойдет сервер с очень дешевой конфигурацией, например CX21 на https://www.hetzner.com/cloud

Перед установкой узла вам нужно получить немного токенов AR. Для этого вам понадобится аккаунт в  твиттере. Зайдите на [сайт](https://faucet.arweave.net/), проставьте галки, затем скачайте "json" файл и переименуйте его в "arweave.json". Нажмите на "Open tweet pop-up" и опубликуйте твит. Через некоторое время вы получите небольше количество токенов AR. Затем скопируйте этот файл к себе на сервер с помощью scp или filezilla в домашнюю папку.

### 1. Автоматическая установка

```
wget https://raw.githubusercontent.com/PetrFerz/Instructions-and-guides/main/Kyve.sh
bash Kyve.sh

```
выбирите

1 - установка пакетов, бинарных файлов, создание сервисов.

2 - выход из меню

затем запустите нужный вам пул, например avalanche

```
systemctl restart avalanche
```
При необходимости вы можете изменить количество застейканных токенов

```
STAKE=NEW_STAKE
sed -i.bak -e "s/initialStake .*/initialStake $STAKE/" /etc/systemd/system/avalanche.service
systemctl daemon-reload
systemctl restart avalanche

```

### 2. Ручная установка

Подготовка сервера.
```
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install unzip -y

```
 
Затем для удобства создайте папку kyve
```
mkdir $HOME/kyve
cd $HOME/kyve
```
Скачайте бинарные файлы, которые понадобятся для запуска разных пулов.

```
wget -O evm-linux.zip https://github.com/KYVENetwork/evm/releases/download/v1.0.5/evm-linux.zip
wget -O kyve-bitcoin-linux.zip https://github.com/kyve-org/bitcoin/releases/download/v0.0.0/kyve-bitcoin-linux.zip
wget -O kyve-solana-linux.zip https://github.com/kyve-org/solana/releases/download/v0.0.1/kyve-solana-linux.zip
wget -O kyve-zilliqa-linux.zip https://github.com/kyve-org/zilliqa/releases/download/v0.0.0/kyve-zilliqa-linux.zip
wget -O stacks-linux.zip https://github.com/kyve-org/stacks/releases/download/v0.0.2/stacks-linux.zip
wget -O celo-linux.zip https://github.com/kyve-org/celo/releases/download/v0.0.0/kyve-celo-linux.zip
wget -O near-linux.zip https://github.com/kyve-org/near/releases/download/v0.0.1/kyve-near-linux.zip

```
Распакуйте архивы, затем сделате бинарные файлы исполняемыми и перенесите их в папку /usr/local/bin/

```
unzip -o "*.zip"
chmod +x kyve-evm-linux kyve-solana-linux kyve-zilliqa-linux bitcoin-linux stacks-linux kyve-celo-linux  kyve-near-linux
mv kyve-evm-linux kyve-solana-linux kyve-zilliqa-linux bitcoin-linux stacks-linux kyve-near-linux  kyve-celo-linux /usr/local/bin/

```

Теперь можно создавать сервисные файлы для каждого пула
```
MNEMONIC="сид фраза (мнемоника)"
```
```
STAKE="количество токенов, которое вы хотите застейкать"
```
пул Moonbeam
```
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

```

пул Avalanche

```
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


```
пул Bitcoin

```
echo "[Unit]
Description=Bitcoin
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which bitcoin-linux) --poolId 3 --mnemonic \"$MNEMONIC\" --keyfile $HOME/arweave.json --initialStake $STAKE
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/kyve/service/bitcoin.service

```

пул Solana

```
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

```

пул Zilliqa

```
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

```

пул Near
```
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

```

пул Celo

```
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

```

пул Evmos
```
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

```

Затем нужно перенести сервисные файлы в папку /etc/systemd/system/
```
mv $HOME/kyve/service/* /etc/systemd/system/
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl daemon-reload
sudo systemctl restart systemd-journald
```

Запуск пула на примере Avalanche

```
systemctl restart avalanche

```
Вы так же можете перезапустить узел с новым значением количества токенов, которые вы хотите застейкать на себя.

```
STAKE=NEW_STAKE
sed -i.bak -e "s/initialStake .*/initialStake $STAKE/" /etc/systemd/system/avalanche.service
systemctl daemon-reload
systemctl restart avalanche

```
просмотр логов

```
journalctl -u avalanche -f

```
Команда Kyve постоянно добавляет новые пулы. Надеюсь данный гайд поможет вам понять принцип запуска узлов Kyve. 

