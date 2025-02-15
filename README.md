# ⚡️ Run Nexus Prover (Testnet 2)  with Single Line Command ⚡️

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
[ -f "nexus.sh" ] && rm nexus.sh; wget -q https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/nexus.sh && chmod +x nexus.sh && ./nexus.sh
```
OR
```
[ -f "nexus.sh" ] && rm nexus.sh; curl -sSf https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/nexus.sh -o nexus.sh && chmod +x nexus.sh && ./nexus.sh
```
**It can take upto 15 Minutes to start till than grab a coffee!

3. Press ```Ctrl+A+D``` To exit and don't press ctrl+X ❌

Thanks !!

