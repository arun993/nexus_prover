# ⚡️Simple Guided to Run Nexus Prover CLI (Testnet 2)  ⚡️

### Pre requirements 
1. Any ubuntu terminal (VPS / Wsl)
2. There is no min. system requiremet but i recommand 4GB RAM and 4 cores CPU (The higher your speces the more points you will get per second)
3. Extract your Nexus Prover ID

### Open your terminal follow these steps
1. Install Screen 
```
sudo apt update && sudo apt install screen -y && screen -S nexus
```
2. Run using one of the following commands
```
[ -f "nexus.sh" ] && rm nexus.sh; wget -q https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/Nexus.sh && chmod +x Nexus.sh && ./Nexus.sh
```
OR
```
[ -f "nexus.sh" ] && rm nexus.sh; curl -sSf https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/Nexus.sh -o Nexus.sh && chmod +x Nexus.sh && ./Nexus.sh
```
**It can take upto 15 Minutes to start till than grab a coffee!

3. Press ```Ctrl+A+D``` To exit and don't press ctrl+C ❌
4. You can check logs by connecting screen again ``` screen -r nexus``` 

:) Follow me on X for more guides : https://x.com/Arun__993  Thanks !!

