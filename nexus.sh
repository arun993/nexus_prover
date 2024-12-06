#!/bin/sh

rustc --version || curl https://sh.rustup.rs -sSf | sh
NEXUS_HOME=$HOME/.nexus

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

PROVER_ID=$(cat "$NEXUS_HOME/prover-id" 2>/dev/null)

if [ -z "$NONINTERACTIVE" ] && [ "${#PROVER_ID}" -ne 28 ]; then
    echo "To receive credit for proving in Nexus testnets, click on your prover ID"
    echo "(bottom left) at https://beta.nexus.xyz/ to copy the full Prover ID and"
    echo "paste it here. Press Enter to continue."
    
    while true; do
        read -p "Prover ID (optional)> " PROVER_ID </dev/tty
        if [ -z "$PROVER_ID" ]; then
            echo "Prover ID is empty. Skipping..."
            break
        fi

        if [ ${#PROVER_ID} -eq 28 ]; then
            # Backup existing Prover ID if it exists
            if [ -f "$NEXUS_HOME/prover-id" ]; then
                echo "Copying $NEXUS_HOME/prover-id to $NEXUS_HOME/prover-id.bak"
                cp "$NEXUS_HOME/prover-id" "$NEXUS_HOME/prover-id.bak"
            fi
            # Save the new Prover ID
            echo "$PROVER_ID" > "$NEXUS_HOME/prover-id"
            echo "Prover ID saved to $NEXUS_HOME/prover-id."
            break
        else
            echo "Invalid Prover ID. Please ensure it is exactly 28 characters."
        fi
    done
fi

REPO_PATH=$NEXUS_HOME/network-api
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating.";
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))

(cd $REPO_PATH/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)

