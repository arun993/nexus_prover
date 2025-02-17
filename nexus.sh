#!/bin/sh


curl -s https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/logo.sh | bash

sleep 3

sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev git-all
sudo apt install -y protobuf-compiler
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source $HOME/.cargo/env
rustc --version || curl https://sh.rustup.rs -sSf | sh

NEXUS_HOME=$HOME/.nexus
GREEN='\033[1;32m'
ORANGE='\033[1;33m'
NC='\033[0m' # No Color

# Check if .nexus directory exists; if not, create it
if [ ! -d "$NEXUS_HOME" ]; then
    mkdir -p "$NEXUS_HOME"
    echo "${GREEN}Created directory: $NEXUS_HOME${NC}"
else
    echo "${ORANGE}Directory $NEXUS_HOME already exists. Skipping creation.${NC}"
fi

while [ -z "$NONINTERACTIVE" ] && [ ! -f "$NEXUS_HOME/prover-id" ]; do
    read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        "" ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE != 0 ]; then
  echo Unable to find git. Please install it and try again.
  exit 1;
fi

PROVER_ID=$(cat $NEXUS_HOME/prover-id 2>/dev/null)
if [ -z "$NONINTERACTIVE" ] && [ "${#PROVER_ID}" -ne "28" ]; then
    echo "\nTo receive credit for proving in Nexus testnets..."
    echo "\t1. Go to ${GREEN}https://beta.nexus.xyz${NC}"
    echo "\t2. On the bottom left hand corner, copy the ${ORANGE}prover id${NC}"
    echo "\t3. Paste the ${ORANGE}prover id${NC} here. Press Enter to continue.\n"
    read -p "Please Enter your 28 digit Prover Id > " PROVER_ID </dev/tty
    while [ ! ${#PROVER_ID} -eq "0" ]; do
        if [ ${#PROVER_ID} -eq "28" ]; then
            if [ -f "$NEXUS_HOME/prover-id" ]; then
                echo Copying $NEXUS_HOME/prover-id to $NEXUS_HOME/prover-id.bak
                cp $NEXUS_HOME/prover-id $NEXUS_HOME/prover-id.bak
            fi
            echo "$PROVER_ID" > $NEXUS_HOME/prover-id
            echo Prover id saved to $NEXUS_HOME/prover-id.
            break;
        else
            echo Unable to validate $PROVER_ID. Please make sure the full prover id is copied.
        fi
        read -p "Prover Id (optional)> " PROVER_ID </dev/tty
    done
fi

REPO_PATH=$NEXUS_HOME/network-api
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating.";
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))

(cd $REPO_PATH/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)
